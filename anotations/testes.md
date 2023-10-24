## DEV_DEPENDENCIES
# Utilize essas 3 dependências para teste:
1. test => roda teste com dart sem precisar do flutter
2. mockito => gera versões mocadas
3. faker => gerar valores aleatórios, por exemplo URLs https

## CONFIGURAÇÕES
# rodar todos testes da aplicação
1. Crie o arquivo ".vscode\launch.json" na pasta raiz da aplicação
2. Clique no botão "Add configuration" e selecione a opção "run all tests"

## PADRÕES PARA EXECUÇÃO
1. Iniciar as variáveis no setUp


## TESTES DE WIDGETS
test\ui\pages\login_page_test.dart
nesse arquivo acima foi o primeiro teste que o professor realizou. Todos prâmetros de um widget, são filhos dele. Então para testar se um formfield está com erro, caso ele possua somente um labeltext, pode testar se o Widget possui somente um filho do tipo text. Se houver mais de um, é porque está com o error também

# tearDown
Essa função sempre é chamadda quando termina os testes. É como se fosse um dispose