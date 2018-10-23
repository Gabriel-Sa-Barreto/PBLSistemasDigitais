# PBLSistemasDigitais
Projetos voltados ao desenvolvimento em FPGA

Está primeira parte está voltado ao desenvolvimento de uma IHM (Interface homem-máquina) utilizando periféricos como LCD, pushButtons e leds através do uso de uma FPGA e o processador Nios II disponibilizado pela Altera. A FPGA utilizada foi a cyclone IV.

-Foi utilziado o Quartus 18.1

Passo para rodar o projeto:

1 - Abrir o Quartus

2 - Em File -> Open Project

3 - Selecionar a pasta PBLSistemasDigitais

4 - Selecionar o arquivo niosII

5 - Compila o projeto

6 - Colocar a arquitetura no fpga

7 - Abrir o Nios Eclipse

8 - Compilar

9 - Ir na opção de rodar no hardware


Descarregar o NiosII na arquitetura do FPGA:

Após abrir o quartus versão 18.1, é necessário abrir o projeto e clicar na opção de compilação. Após complilado, se deslocar para a opção "programmer" no campo superior onde está escrito "tools". Escolhe a opção USB-Blaster para envio do programa e pronto.

Descarregar o programa C:

Abra o programa Eclipse no campo "tools" do Quartus, clique com o segundo botão na pasta nios_1_bsp, depois opção nios->generate bsp. Depois de finalizado, compile o projeto clicando com o segundo botão na pasta nios_1, depois "build-project". Após o término de todo esse processo, clique em "Run" para rodar o programa completo na FPGA.
