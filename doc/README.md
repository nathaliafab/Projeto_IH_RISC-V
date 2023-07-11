## 1. Diagrama de Blocos

![Diagrama de Blocos](/doc/PipeLine.png)

## 2. Explicação Detalhada
### 2.1 Inicialização
Para implementar a ideia de Pipeline, introduzimos quatro registradores de buffer entre cada estágio.
- `Register A`: registrador entre os estágios IF e ID.
- `Register B`: registrador entre os estágios ID e EX.
- `Register C`: registrador entre os estágios EX e MEM.
- `Register D`: registrador entre os estágios MEM e WB.

Todos os quatro registradores de buffer serão atualizados na borda positiva do sinal de clock (posedge). Além disso, no início, que corresponde à borda positiva do sinal de reset, todos os 4 registradores serão definidos como 0.

### 2.2 Estágio de Busca de Instrução
#### 2.2.1 Memória de Instrução
Neste estágio, a [Memória de Instrução](/design/instructionmemory.sv) buscará a instrução específica de acordo com o valor gerado pelo PC. As instruções do programa são inicializadas na memória por meio de um arquivo `instruction.mif`.
- Para mais informações, consulte o [README.md](/verif/README.md) do diretório `verif`.

Em seguida, na borda positiva do ciclo de clock seguinte, essa instrução será gravada no `Register A` para que um novo código de instrução possa ser buscado.

#### 2.2.2 Multiplexador de Seleção do Próximo PC
Um multiplexador 2 para 1 controla o valor que deve ser usado para buscar a instrução no próximo ciclo de clock.
- A primeira opção é o PC atual + 4.
- A segunda opção é o valor do PC gerado pela [Unidade de Branch](/design/BranchUnit.sv), que é selecionado somente quando o branch for tomado. O controle do multiplexador também vem da Unidade de Branch.

### 2.3 Estágio de Decodificação de Instrução
Neste estágio, o código da instrução adquirida do `Register A` será dividido em diferentes partes e usado pelo [controlador](/design/Controller.sv), [gerador de imediatos](/design/imm_Gen.sv) e [banco de registradores](/design/RegFile.sv). Em vez de conectar esses controles e dados lidos diretamente a diferentes unidades de operação, armazenamos eles no `Register B` para uso posterior.

### 2.4 Estágio de Execução
Neste estágio, usamos os sinais de dados e controle do `Register B` para controlar a Unidade de Branch e a ALU.

#### 2.4.1 Unidade de Branch
A `Unidade de Branch` projetada é responsável pelo cálculo do próximo valor do PC se uma instrução de branch for buscada no estágio IF. Se a instrução de BRANCH for tomada, a saída `PcSel` será definida como 1.

Quanto ao novo valor do PC (saída `BrPc`), ele será definido como PC+Imm se o BRANCH for tomado.

Tanto `BrPC` quanto `PcSel` serão conectados diretamente ao multiplexador `PcSel`. Isso significa que, sempre que a Unidade de Branch concluir seu trabalho, o multiplexador de seleção do PC terá tudo o que precisa. No entanto, o processador ainda precisa aguardar até a próxima borda positiva para fazer a seleção real. Portanto, cada instrução de branch tomada precisará descartar 2 instruções pré-processadas nos estágios IF e ID naquele momento.

#### 2.4.2 ALU com Forwarding
Dois multiplexadores de seleção de forwarding são adicionados às entradas `SrcA` e `SrcB` da ALU.

- Se não houver hazard, o multiplexador selecionará `RD1` e `RD2` do `Register B`.
- Se ocorrer um hazard EX, o multiplexador selecionará `AluResult` para `SrcA` ou `SrcB`.
- Se ocorrer um hazard MEM, o multiplexador selecionará `WB-Data` para `SrcA` ou `SrcB`.

### 2.5 Estágio de Operação de Memória
Os sinais de controle e dados vêm do `Register C`.

### 2.6 Estágio de Escrita de Dados
Nesta etapa, um multiplexador 4 para 1 selecionará o sinal correto que deve ser escrito no registrador, se a escrita for necessária.

- Observação: se uma instrução descartada entrar neste estágio, o sinal `WB-Data` ainda pode ter um valor incorreto, mas isso não significa nada e não afetará o RegFile.

### 2.7 Unidade de Detecção de Hazards
Uma `Unidade de Detecção de Hazards` é adicionada ao datapath do pipeline. Se um hazard de dependência de dados for detectado, um sinal de stall será gerado e enviado ao PC, `Register A` e `Register B`.

- O PC verifica o sinal de stall a cada borda positiva do clock. Sempre que esse sinal tiver o valor 1, a saída do PC não será alterada.

- `Register A` verifica o sinal de stall a cada borda positiva do clock. Sempre que esse sinal tiver o valor 1, o `Register A` não será atualizado nesse momento, mas manterá os dados atuais. Isso funciona como uma paralisação da instrução atual no estágio ID, o que significa uma espera de um ciclo.

- `Register B` verifica o sinal de stall a cada borda positiva do clock. Sempre que esse sinal tiver o valor 1, o `Register B` esvaziará todos os dados armazenados dentro dele para evitar que a instrução atual entre no próximo estágio, o que funciona como uma instrução NOP.

### 2.8 Sinal de Flush de Registrador
O sinal de descarte funciona de maneira semelhante ao sinal de stall no PC, `Register A` e `Register B`, mas é gerado pela Unidade de Branch. O objetivo de ter esse sinal é descartar instruções incorretas que foram buscadas e executadas antes de qualquer instrução de branch tomada.

- O PC verifica o sinal de stall a cada borda positiva do clock. Sempre que esse sinal tiver o valor 1, a saída do PC não será alterada.

- Os `Registers A` e `B` verificam o sinal de stall a cada borda positiva do clock. Sempre que esse sinal tiver o valor 1, os `Registers` esvaziarão todos os dados armazenados dentro deles para evitar que dados inválidos entrem no próximo estágio, o que também funciona como uma instrução NOP.
