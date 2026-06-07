# AgroSpace

**Monitoramento de lavouras com dados de satelite da NASA e persistencia em Firebase**

Aplicativo Flutter desenvolvido para a **Global Solution - Industria Espacial**. O AgroSpace usa dados agroclimaticos de satelite da NASA POWER para apoiar produtores rurais no acompanhamento de lavouras, detectando indicios de **seca**, **excesso de agua** e **risco de pragas** com diagnosticos automaticos.

As lavouras cadastradas sao salvas no **Cloud Firestore**, permitindo que os dados continuem disponiveis ao reabrir o app e possam ser centralizados no projeto Firebase. Enquanto o Firebase nao estiver inicializado, o app mantem um fallback local com `SharedPreferences`.

---

## Descricao da solucao

Produtores rurais podem perder produtividade quando nao existe monitoramento continuo das areas de cultivo. Visitas presenciais sao caras, demoradas e problemas como estiagem, encharcamento do solo e risco de pragas muitas vezes aparecem quando o dano ja esta avancado.

O **AgroSpace** usa dados de observacao da Terra para transformar cada talhao cadastrado em uma area monitorada a distancia. A partir das coordenadas geograficas da lavoura, o app consulta a base **NASA POWER** e analisa os ultimos dias de temperatura, precipitacao, umidade relativa e umidade do solo.

O resultado e apresentado em uma tela de diagnostico visual, com indicadores de risco, metricas medias do periodo e graficos de tendencia.

---

## Fluxo do aplicativo

1. **Home**: apresenta a proposta da solucao, o passo a passo de uso e os ODS atendidos.
2. **Minhas lavouras**: lista as lavouras cadastradas no Firestore, permitindo abrir detalhes ou remover registros.
3. **Cadastro de lavoura**: formulario validado com nome, cultura e coordenadas geograficas.
4. **Detalhe / Diagnostico**: consulta a NASA POWER em tempo real e exibe:
   - indicadores de **Seca**, **Excesso de agua** e **Pragas**;
   - status por risco: ok, atencao ou critico;
   - temperatura media, chuva acumulada, umidade relativa e umidade do solo;
   - graficos de temperatura e precipitacao.

A regra de negocio de analise fica isolada no `AnaliseService`, sem logica de diagnostico dentro das telas.

---

## Requisitos atendidos

| Requisito | Implementacao |
|-----------|---------------|
| **Arquitetura MVVM** | Separacao em `core`, `data`, `viewmodels`, `views` e `widgets`. |
| **ViewModels** | `LavourasViewModel`, `DetalheLavouraViewModel` e `CadastroLavouraViewModel` com `ChangeNotifier` + `Provider`. |
| **Navegacao** | Rotas nomeadas em `core/routes/app_routes.dart`. |
| **API real** | `NasaPowerService` consome a API publica NASA POWER. |
| **Estados de UI** | `UiInitial`, `UiLoading`, `UiSuccess` e `UiError`. |
| **Persistencia remota** | `Cloud Firestore` via `FirestoreLavouraStorage`. |
| **Fallback local** | `SharedPreferences` via `LocalStorage`, usado quando o Firebase nao esta inicializado. |
| **Repositorio** | `LavouraRepository` depende do contrato `LavouraStorage`, permitindo trocar a fonte de dados. |
| **Componentizacao** | Widgets reutilizaveis como `AppTopBar`, `LavouraCard`, `IndicadorCard`, `MetricTile`, `StatusChip`, `ClimaChart`, `SectionHeader`, `StateViews` e `ResponsiveContent`. |
| **Testes** | Testes de persistencia com fake em memoria e smoke test da Home. |

---

## Estrutura do projeto

```text
lib/
|-- main.dart                         # Inicializa Flutter, Firebase, providers, tema e rotas
|-- firebase_options.dart             # Configuracao gerada pelo FlutterFire CLI
|-- core/
|   |-- constants/                    # Cores, textos e dimensoes
|   |-- firebase/                     # Bootstrap do Firebase
|   |-- routes/                       # Rotas nomeadas
|   |-- state/                        # UiState
|   |-- theme/                        # AppTheme
|   `-- utils/                        # Formatadores
|-- data/
|   |-- datasources/
|   |   |-- lavoura_storage.dart      # Contrato de persistencia
|   |   |-- firestore_lavoura_storage.dart
|   |   |-- local_storage.dart
|   |   `-- lavoura_storage_factory.dart
|   |-- models/                       # Lavoura, Cultura, Diagnostico, NASA POWER
|   |-- repositories/                 # LavouraRepository e MonitoramentoRepository
|   `-- services/                     # NASA POWER e regras de analise
|-- viewmodels/                       # ChangeNotifier por tela
|-- views/                            # Home, lavouras, cadastro e detalhe
`-- widgets/                          # Componentes reutilizaveis

test/
|-- lavoura_persistence_test.dart
`-- widget_test.dart
```

---


## API utilizada - NASA POWER

- **Endpoint:** `https://power.larc.nasa.gov/api/temporal/daily/point`
- **Comunidade:** `AG` (Agroclimatology)
- **Chave de API:** nao requer chave
- **Documentacao:** https://power.larc.nasa.gov/docs/services/api/
- **Parametros consultados:**
  - `T2M`, `T2M_MAX`, `T2M_MIN`: temperatura do ar a 2 m
  - `PRECTOTCORR`: precipitacao corrigida
  - `RH2M`: umidade relativa a 2 m
  - `GWETROOT`: umidade do solo na zona radicular

Os dados da NASA POWER podem ter defasagem de alguns dias, por isso o app consulta uma janela recente encerrando alguns dias antes da data atual.

---

## Como executar

Pre-requisitos:

- Flutter SDK 3.19+ com Dart 3.3+
- Projeto Firebase configurado
- Cloud Firestore criado em modo nativo
- Regras do Firestore permitindo acesso durante os testes

```powershell
flutter pub get
flutter run
```

Para rodar os testes:

```powershell
flutter test
```

---

## Dependencias principais

| Pacote | Uso |
|--------|-----|
| `provider` | Gerenciamento de estado no padrao MVVM |
| `http` | Consumo da API NASA POWER |
| `firebase_core` | Inicializacao do Firebase |
| `cloud_firestore` | Persistencia remota das lavouras |
| `shared_preferences` | Fallback local quando Firebase nao inicializa |


---

## Testes

A suite cobre:

- Persistencia de lavouras atraves do contrato `LavouraStorage`, usando fake em memoria.
- Carregamento de lavouras pelo `LavourasViewModel`.
- Smoke test da `HomeScreen`.

Comando:

```powershell
flutter test
```

Resultado validado apos a integracao Firebase:

```text
All tests passed!
```

---

## Integrantes do grupo

| Nome | RM |
|------|----|
| Diogo Witzel | RM552754 |
| Lucas Domingues | RM553304 |
| Victor Morelli | RM553338 |

---

## Links

- **Video Pitch:** adicionar o link do video aqui
