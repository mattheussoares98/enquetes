> ## PADRÕES DO PROJETO

## Classes abstratas || interface || protocolo
1. Sempre ficam como tracejado no diagrama
2. Depende da entidade

## Domain || Data
1. Onde ficam as regras de negócio
2. Não tem implementação de código
3. Não tem classes concretas. A implementação das classes abstratas ficam em outras camadas

## Entidade
1. Resposta de uso da classe abstrata

> ## IMPORTS E EXPORTS
1. Sempre que criar uma pasta, precisa criar um arquivo com o mesmo nome e exportar tudo que está nessa pasta
2. Package de terceiros deixa sempre na parte de cima do arquivo, separado
3. Quando estiver importando uma biblioteca da própria pasta lib, não usar o package na frente do import
4. Quando houver algum import do dart, deve ficar entre o package e os imports da própria lib

## GERAL
1. Uma classe deve ter somente uma responsabilidade! Não deve ter mais de uma!

## Presenter
1. Responsável pelo gerenciamento de estado
