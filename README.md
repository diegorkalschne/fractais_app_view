# Fractais
Aplicativo para visualização de fractais (conjunto de Mandelbrot e de Julia), conforme API desenvolvida em [Python](https://github.com/diegorkalschne/fractais_mpi_threads).

- Flutter 3.24.0

# Debug
1. flutter pub get
2. flutter run

- É necessário trocar o link na variável `endpoint`, no arquivo `mandelbrot_repository.dart`. </br>
> Recomendado utilizar algum endereço com HTTPS, pois HTTP pode dar erro com a API. Uma solução é utilizar o [Ngrok](https://ngrok.com/).