# Plano de Integração de API — AchadosBR

**Complementa:** `api_report.md` (contrato completo dos endpoints)
**Data:** 2026-08-14

---

## 1. Situação atual

O app Flutter (`AchouAchado/`) hoje consome dados 100% mocados:

- `lib/data/mock_deals.dart`
- `lib/data/mock_affiliates.dart`

Os `services/*.dart` (ex: `product_service.dart`, `boost_service.dart`, `review_service.dart`) leem/escrevem diretamente nesses mocks e em memória local.

## 2. Objetivo

Preparar o projeto para trocar os mocks por dados reais, sem reescrever as telas:

1. **Dio** → cliente HTTP para consumir a API (hoje inexistente, no futuro **Supabase**).
2. **Drift** → banco local (SQLite) para cache offline e leitura rápida (ex: deals salvos, últimos deals vistos).
3. Os **contratos de dados continuam os mesmos** já documentados em `api_report.md` — os models (`Deal`, `AffiliateProduct`, `Review`, etc.) não mudam de forma.

## 3. O que foi adicionado ao projeto

| Pacote | Papel |
|---|---|
| `dio` | Cliente HTTP (requests para a API/Supabase) |
| `drift` + `sqlite3_flutter_libs` | Banco local SQLite, para cache/offline |
| `path_provider` + `path` | Localizar o arquivo do banco local no device |
| `drift_dev` + `build_runner` (dev) | Geração de código do Drift (`*.g.dart`) |

Arquivos criados:

- `lib/data/remote/api_client.dart` — instância única do Dio, com `baseUrl` e interceptor de `Authorization: Bearer <token>`.
- `lib/data/local/local_database.dart` — esqueleto do banco Drift (`CachedDeals`, `SavedDealIds`).

## 4. Próximos passos

1. Rodar o gerador de código do Drift:
   ```bash
   dart run build_runner build -d
   ```
2. Quando o **Supabase** estiver criado, atualizar `ApiClient._defaultBaseUrl` com a URL do projeto (`Settings > API > Project URL`), ou consumir o Supabase direto via `supabase_flutter` (avaliar se substitui o Dio para chamadas ao Supabase, mantendo o Dio só para APIs externas, se houver).
3. Trocar, service por service, a fonte de dados mocada por chamadas via `ApiClient`, seguindo os endpoints já especificados em `api_report.md` (ex: `GET /deals`, `POST /deals/{id}/vote`).
4. Usar o `LocalDatabase` (Drift) como cache: gravar o resultado de `GET /deals` localmente e ler dele quando não houver internet.

## 5. Ordem sugerida de migração (dos mocks para API real)

1. Autenticação (`EP-01` a `EP-06`) — necessário para tudo que é autenticado.
2. Deals (`EP-14` a `EP-18`) — tela Home/Busca.
3. Afiliados e vitrine (`EP-19` a `EP-27`).
4. Reviews (`EP-28` a `EP-30`).
5. Boost (`EP-31` a `EP-33`).

---

*Este documento trata do plano de integração (Dio/Drift/Supabase). Para o contrato completo de cada endpoint, ver `api_report.md`.*
