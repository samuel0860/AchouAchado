# Relatório Técnico de API — AchadosBR
**Versão:** 1.0  
**Data:** 2026-07-07  
**Destinatário:** Desenvolvedor Backend  
**Aplicação:** AchadosBR — Plataforma de Promoções e Afiliados  

---

## 1. Visão Geral da API

### 1.1 Base URL
```
https://api.achadosbr.com/v1
```

### 1.2 Formato de Dados
- Todas as requisições e respostas usam **JSON** (`Content-Type: application/json`).
- Datas no formato **ISO 8601**: `2026-01-15T10:30:00Z`.
- Moeda em **BRL** (Real Brasileiro), valores numéricos do tipo `float`.

### 1.3 Fluxo de Autenticação
A API usa autenticação baseada em **JWT (JSON Web Token)**:

1. O usuário realiza login via `POST /auth/login` e recebe um `accessToken` e um `refreshToken`.
2. O `accessToken` tem expiração curta (ex: 15 minutos) e deve ser enviado no header `Authorization: Bearer <token>` em todas as rotas protegidas.
3. O `refreshToken` tem expiração longa (ex: 30 dias) e é usado em `POST /auth/refresh` para obter novos tokens sem novo login.
4. Ao fazer logout, o `refreshToken` é invalidado no servidor.

```
[Registro/Login] → accessToken + refreshToken
       ↓
[Requisiçõs protegidas] → Authorization: Bearer <accessToken>
       ↓
[Token expirado] → POST /auth/refresh → Novo accessToken
       ↓
[Logout] → POST /auth/logout → Invalida refreshToken
```

### 1.4 Autorização por Perfil de Usuário
| Perfil | Permissões |
|--------|-----------|
| `cliente` | Consultar deals, votar, comentar, salvar, postar deal da comunidade |
| `afiliado` | Tudo do cliente + gerenciar produtos próprios, vitrine, impulsionamento |

### 1.5 Estrutura Padrão de Resposta de Erro

```json
{
  "success": false,
  "error": {
    "code": "DEAL_NOT_FOUND",
    "message": "O deal solicitado não foi encontrado.",
    "details": {}
  }
}
```

---

## 2. Entidades da API

### 2.1 User (Usuário)
```json
{
  "id": "string (UUID)",
  "name": "string",
  "email": "string",
  "isEmailVerified": "boolean",
  "isAffiliate": "boolean",
  "userType": "string (enum: cliente | afiliado)",
  "createdAt": "string (ISO 8601)",
  "bio": "string | null",
  "avatarColor": "string (hex, ex: #7C3AED) | null"
}
```

### 2.2 Deal (Promoção/Achado)
```json
{
  "id": "string (UUID)",
  "title": "string",
  "description": "string",
  "originalPrice": "number (float)",
  "dealPrice": "number (float)",
  "couponCode": "string | null",
  "imageUrl": "string (URL)",
  "store": "string",
  "storeLogoUrl": "string (URL)",
  "dealUrl": "string (URL)",
  "category": "string (enum)",
  "upvotes": "number (int)",
  "downvotes": "number (int)",
  "comments": "number (int)",
  "postedAt": "string (ISO 8601)",
  "postedBy": "string (username)",
  "postedById": "string (UUID do usuário)",
  "postedByAvatar": "string | null",
  "isVerified": "boolean",
  "isHot": "boolean",
  "hasFreeShipping": "boolean",
  "expiresAt": "string (ISO 8601) | null",
  "affiliateId": "string (UUID) | null",
  "discountPercent": "number (float, calculado)",
  "savings": "number (float, calculado)",
  "temperature": "number (int, calculado: upvotes - downvotes)"
}
```

**Enum DealCategory:**
`eletronicos` | `moda` | `casa` | `beleza` | `alimentacao` | `jogos` | `esporte` | `livros` | `viagem` | `outros`

### 2.3 Affiliate (Afiliado — perfil público)
```json
{
  "id": "string (UUID)",
  "userId": "string (UUID)",
  "name": "string",
  "bio": "string",
  "themeColorHex": "string (hex)",
  "totalDeals": "number (int)",
  "rating": "number (float, 1.0–5.0)",
  "displayName": "string",
  "profileImageUrl": "string | null",
  "bannerUrls": "array[string]",
  "createdAt": "string (ISO 8601)"
}
```

### 2.4 AffiliateProduct (Produto do Afiliado — vitrine)
```json
{
  "id": "string (UUID)",
  "affiliateId": "string (UUID)",
  "title": "string",
  "description": "string",
  "price": "number (float)",
  "originalPrice": "number (float)",
  "discountPercent": "number (float)",
  "couponCode": "string | null",
  "imageUrls": "array[string (URL)]",
  "highlightColor": "string (hex)",
  "badgePosition": "string (enum: topLeft | topRight | center | bottomLeft | bottomRight)",
  "isActive": "boolean",
  "store": "string",
  "storeId": "string",
  "category": "string",
  "hasFreeShipping": "boolean",
  "createdAt": "string (ISO 8601)"
}
```

### 2.5 Review (Avaliação)
```json
{
  "id": "string (UUID)",
  "dealId": "string (UUID)",
  "userId": "string (UUID)",
  "userName": "string",
  "userAvatarColor": "string (hex)",
  "rating": "number (int, 1–5)",
  "comment": "string",
  "emojiReactions": "array[string]",
  "createdAt": "string (ISO 8601)",
  "isVerifiedPurchase": "boolean"
}
```

### 2.6 AffiliatePage (Configuração da vitrine pública)
```json
{
  "affiliateId": "string (UUID)",
  "displayName": "string",
  "bio": "string",
  "themeColorHex": "string (hex)",
  "bannerUrls": "array[string (URL)]",
  "profileImageUrl": "string | null"
}
```

### 2.7 Boost (Impulsionamento)
```json
{
  "id": "string (UUID)",
  "productId": "string (UUID do AffiliateProduct)",
  "affiliateId": "string (UUID)",
  "plan": "string (enum: basico | pro | premium)",
  "startDate": "string (ISO 8601)",
  "endDate": "string (ISO 8601)",
  "isActive": "boolean",
  "priority": "number (int: 10 | 50 | 100)",
  "planName": "string",
  "planPrice": "string",
  "durationDays": "number (int)"
}
```

### 2.8 UserData (Dados locais do usuário)
```json
{
  "savedDealIds": "array[string]",
  "visitHistory": "array[{ id, title, imageUrl, visitedAt }]",
  "alertCategories": "array[string]",
  "alertsEnabled": "boolean"
}
```

---

## 3. Relacionamento entre Entidades

```
User ──────────────────────────── 1:1 ──── UserData
User (afiliado) ──────────────── 1:1 ──── AffiliatePage
User (afiliado) ──────────────── 1:N ──── AffiliateProduct
User ──────────────────────────── 1:N ──── Deal (postedBy)
User (afiliado) ──────────────── 1:N ──── Deal (via affiliateId)
User ──────────────────────────── 1:N ──── Review
Deal ──────────────────────────── 1:N ──── Review
AffiliateProduct ─────────────── 1:1 ──── Boost (opcional)
Deal ──────────────────────────── N:1 ──── Affiliate (via affiliateId)
```

---

## 4. Headers Obrigatórios

| Header | Valor | Obrigatório em |
|--------|-------|---------------|
| `Content-Type` | `application/json` | Todas as requisições com body |
| `Authorization` | `Bearer <accessToken>` | Rotas protegidas |
| `Accept` | `application/json` | Todas as requisições |

---

## 5. Endpoints — Autenticação

---

### EP-01 — Cadastro de Usuário
| Campo | Valor |
|-------|-------|
| **Nome** | Register |
| **Método** | POST |
| **Rota** | `/auth/register` |
| **Autenticação** | Não |

**Descrição:** Registra um novo usuário (cliente ou afiliado). Retorna o perfil criado e os tokens de acesso.

**Body (obrigatório):**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `name` | string | ✅ | 2–100 caracteres |
| `email` | string | ✅ | Formato e-mail válido, único no sistema |
| `password` | string | ✅ | Mínimo 6 caracteres |
| `userType` | string | ✅ | Enum: `cliente` \| `afiliado` |

**Exemplo de Requisição:**
```json
{
  "name": "João Silva",
  "email": "joao@email.com",
  "password": "minhasenha123",
  "userType": "cliente"
}
```

**Resposta de Sucesso — 201 Created:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid-001",
      "name": "João Silva",
      "email": "joao@email.com",
      "isEmailVerified": false,
      "isAffiliate": false,
      "userType": "cliente",
      "createdAt": "2026-07-07T19:00:00Z",
      "bio": null,
      "avatarColor": "#7C3AED"
    },
    "accessToken": "eyJhbGciOiJIUzI1...",
    "refreshToken": "eyJhbGciOiJIUzI1...",
    "expiresIn": 900
  }
}
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 400 | `VALIDATION_ERROR` | Campos inválidos ou ausentes |
| 409 | `EMAIL_ALREADY_EXISTS` | E-mail já cadastrado |
| 500 | `SERVER_ERROR` | Erro interno |

**Regras de Negócio:**
- Ao criar um usuário do tipo `afiliado`, o campo `isAffiliate` deve ser `true` e um registro vazio em `AffiliatePage` deve ser criado automaticamente.
- O `avatarColor` padrão é `#7C3AED`.
- `isEmailVerified` começa como `false`; o backend deve enviar e-mail de verificação.

---

### EP-02 — Login
| Campo | Valor |
|-------|-------|
| **Nome** | Login |
| **Método** | POST |
| **Rota** | `/auth/login` |
| **Autenticação** | Não |

**Descrição:** Autentica o usuário com e-mail e senha. Retorna os tokens JWT.

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `email` | string | ✅ | Formato e-mail |
| `password` | string | ✅ | Não vazio |

**Exemplo de Requisição:**
```json
{
  "email": "joao@email.com",
  "password": "minhasenha123"
}
```

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid-001",
      "name": "João Silva",
      "email": "joao@email.com",
      "isEmailVerified": true,
      "isAffiliate": false,
      "userType": "cliente",
      "createdAt": "2026-07-07T19:00:00Z",
      "bio": "Amo encontrar ofertas!",
      "avatarColor": "#10B981"
    },
    "accessToken": "eyJhbGciOiJIUzI1...",
    "refreshToken": "eyJhbGciOiJIUzI1...",
    "expiresIn": 900
  }
}
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 400 | `VALIDATION_ERROR` | Campos ausentes |
| 401 | `INVALID_CREDENTIALS` | E-mail não encontrado ou senha incorreta |
| 500 | `SERVER_ERROR` | Erro interno |

> ⚠️ Não distinguir publicamente se o erro foi e-mail ou senha para segurança. Use a mensagem genérica "Credenciais inválidas."

---

### EP-03 — Refresh Token
| Campo | Valor |
|-------|-------|
| **Nome** | Refresh Token |
| **Método** | POST |
| **Rota** | `/auth/refresh` |
| **Autenticação** | Não (usa refreshToken) |

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `refreshToken` | string | ✅ | JWT válido e não expirado |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1...",
    "expiresIn": 900
  }
}
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 401 | `INVALID_REFRESH_TOKEN` | Token inválido, expirado ou revogado |

---

### EP-04 — Logout
| Campo | Valor |
|-------|-------|
| **Nome** | Logout |
| **Método** | POST |
| **Rota** | `/auth/logout` |
| **Autenticação** | ✅ Bearer Token |

**Body:**
| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| `refreshToken` | string | ✅ |

**Resposta de Sucesso — 200 OK:**
```json
{ "success": true }
```

---

### EP-05 — Esqueci minha senha
| Campo | Valor |
|-------|-------|
| **Nome** | Forgot Password |
| **Método** | POST |
| **Rota** | `/auth/forgot-password` |
| **Autenticação** | Não |

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `email` | string | ✅ | Formato e-mail |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "message": "Se o e-mail existir, você receberá as instruções de redefinição."
}
```

> **Regra de Segurança:** Sempre retorna 200, mesmo que o e-mail não exista (evita enumeração de usuários).

---

### EP-06 — Redefinir Senha
| Campo | Valor |
|-------|-------|
| **Nome** | Reset Password |
| **Método** | POST |
| **Rota** | `/auth/reset-password` |
| **Autenticação** | Não (usa token de reset enviado por e-mail) |

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `email` | string | ✅ | Formato e-mail |
| `resetToken` | string | ✅ | Token recebido por e-mail |
| `newPassword` | string | ✅ | Mínimo 6 caracteres |

**Resposta de Sucesso — 200 OK:**
```json
{ "success": true }
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 400 | `INVALID_RESET_TOKEN` | Token inválido ou expirado |
| 404 | `USER_NOT_FOUND` | E-mail não encontrado |

---

## 6. Endpoints — Usuário / Perfil

---

### EP-07 — Obter Perfil do Usuário Autenticado
| Campo | Valor |
|-------|-------|
| **Nome** | Get My Profile |
| **Método** | GET |
| **Rota** | `/users/me` |
| **Autenticação** | ✅ Bearer Token |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "id": "uuid-001",
    "name": "João Silva",
    "email": "joao@email.com",
    "isEmailVerified": true,
    "isAffiliate": false,
    "userType": "cliente",
    "createdAt": "2026-07-07T19:00:00Z",
    "bio": "Amo encontrar ofertas!",
    "avatarColor": "#10B981"
  }
}
```

---

### EP-08 — Atualizar Perfil
| Campo | Valor |
|-------|-------|
| **Nome** | Update Profile |
| **Método** | PATCH |
| **Rota** | `/users/me` |
| **Autenticação** | ✅ Bearer Token |

**Body (todos opcionais, pelo menos 1 obrigatório):**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `name` | string | ❌ | 2–100 caracteres |
| `bio` | string | ❌ | Máx. 300 caracteres |
| `avatarColor` | string | ❌ | Hex válido: `#RRGGBB` |

**Exemplo de Requisição:**
```json
{
  "name": "João S.",
  "bio": "Caçador de promoções tech!",
  "avatarColor": "#3B82F6"
}
```

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "id": "uuid-001",
    "name": "João S.",
    "bio": "Caçador de promoções tech!",
    "avatarColor": "#3B82F6"
  }
}
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 400 | `VALIDATION_ERROR` | Campos inválidos |
| 401 | `UNAUTHORIZED` | Token ausente ou inválido |

---

### EP-09 — Obter Dados do Usuário (Salvos, Histórico, Alertas)
| Campo | Valor |
|-------|-------|
| **Nome** | Get User Data |
| **Método** | GET |
| **Rota** | `/users/me/data` |
| **Autenticação** | ✅ Bearer Token |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "savedDealIds": ["deal-001", "deal-005"],
    "visitHistory": [
      {
        "id": "deal-001",
        "title": "iPhone 15 Pro Max 256GB",
        "imageUrl": "https://...",
        "visitedAt": "2026-07-07T18:00:00Z"
      }
    ],
    "alertCategories": ["eletronicos", "moda"],
    "alertsEnabled": true
  }
}
```

---

### EP-10 — Salvar / Remover Deal (Toggle)
| Campo | Valor |
|-------|-------|
| **Nome** | Toggle Save Deal |
| **Método** | POST |
| **Rota** | `/users/me/saved-deals/{dealId}` |
| **Autenticação** | ✅ Bearer Token |

**Path Params:**
| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| `dealId` | string | ✅ |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "saved": true,
    "dealId": "deal-001"
  }
}
```
> Se o deal já estava salvo, o backend remove e retorna `"saved": false`.

---

### EP-11 — Registrar Visita a Deal
| Campo | Valor |
|-------|-------|
| **Nome** | Add Visit |
| **Método** | POST |
| **Rota** | `/users/me/visit-history` |
| **Autenticação** | ✅ Bearer Token |

**Body:**
| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| `dealId` | string | ✅ |
| `dealTitle` | string | ✅ |
| `imageUrl` | string | ✅ |

**Resposta de Sucesso — 200 OK:**
```json
{ "success": true }
```

**Regra de Negócio:** Máximo de 50 itens no histórico. Visitas duplicadas sobrescrevem a mais antiga. O histórico é ordenado da visita mais recente para a mais antiga.

---

### EP-12 — Limpar Histórico de Visitas
| Campo | Valor |
|-------|-------|
| **Nome** | Clear Visit History |
| **Método** | DELETE |
| **Rota** | `/users/me/visit-history` |
| **Autenticação** | ✅ Bearer Token |

**Resposta de Sucesso — 200 OK:**
```json
{ "success": true }
```

---

### EP-13 — Atualizar Preferências de Alertas
| Campo | Valor |
|-------|-------|
| **Nome** | Update Alert Preferences |
| **Método** | PATCH |
| **Rota** | `/users/me/alert-preferences` |
| **Autenticação** | ✅ Bearer Token |

**Body:**
| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `alertsEnabled` | boolean | ❌ | Liga/desliga todos os alertas |
| `alertCategories` | array[string] | ❌ | Lista de categorias para alertas |

**Exemplo de Requisição:**
```json
{
  "alertsEnabled": true,
  "alertCategories": ["eletronicos", "jogos", "casa"]
}
```

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "alertsEnabled": true,
    "alertCategories": ["eletronicos", "jogos", "casa"]
  }
}
```

---

## 7. Endpoints — Deals (Promoções)

---

### EP-14 — Listar Deals
| Campo | Valor |
|-------|-------|
| **Nome** | List Deals |
| **Método** | GET |
| **Rota** | `/deals` |
| **Autenticação** | Não (opcional para dados personalizados) |

**Query Params:**
| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `category` | string | ❌ | Filtrar por categoria (enum DealCategory) |
| `sortBy` | string | ❌ | `hot` (padrão) \| `new` \| `discount` |
| `page` | number | ❌ | Página (padrão: 1) |
| `limit` | number | ❌ | Itens por página (padrão: 20, máx: 100) |
| `search` | string | ❌ | Busca textual no título e descrição |
| `affiliateId` | string | ❌ | Filtrar deals de um afiliado específico |
| `hasFreeShipping` | boolean | ❌ | Filtrar por frete grátis |
| `isHot` | boolean | ❌ | Filtrar apenas deals quentes |

**Ordenação `sortBy`:**
- `hot` → ordena por `temperature` (upvotes - downvotes), decrescente.
- `new` → ordena por `postedAt`, decrescente.
- `discount` → ordena por `discountPercent`, decrescente.

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "deals": [
      {
        "id": "deal-001",
        "title": "iPhone 15 Pro Max 256GB Titânio Natural",
        "description": "O iPhone 15 Pro Max com chip A17 Pro...",
        "originalPrice": 9999.00,
        "dealPrice": 6799.00,
        "couponCode": "IPHONE15BR",
        "imageUrl": "https://cdn.achadosbr.com/images/iphone15.png",
        "store": "Amazon",
        "storeLogoUrl": "https://cdn.achadosbr.com/stores/amazon.png",
        "dealUrl": "https://amazon.com.br/...",
        "category": "eletronicos",
        "upvotes": 842,
        "downvotes": 12,
        "comments": 156,
        "postedAt": "2026-07-07T17:00:00Z",
        "postedBy": "TechHunter",
        "postedById": "uuid-aff-001",
        "postedByAvatar": null,
        "isVerified": true,
        "isHot": true,
        "hasFreeShipping": true,
        "expiresAt": "2026-07-08T15:00:00Z",
        "affiliateId": "affiliate_tech",
        "discountPercent": 32.0,
        "savings": 3200.00,
        "temperature": 830
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 134,
      "totalPages": 7
    }
  }
}
```

---

### EP-15 — Obter Deal por ID
| Campo | Valor |
|-------|-------|
| **Nome** | Get Deal |
| **Método** | GET |
| **Rota** | `/deals/{dealId}` |
| **Autenticação** | Não |

**Path Params:**
| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| `dealId` | string | ✅ |

**Resposta de Sucesso — 200 OK:**  
Retorna o objeto `Deal` completo (mesma estrutura do EP-14, sem paginação).

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 404 | `DEAL_NOT_FOUND` | Deal não encontrado |

---

### EP-16 — Criar Deal (Postar Achado)
| Campo | Valor |
|-------|-------|
| **Nome** | Create Deal |
| **Método** | POST |
| **Rota** | `/deals` |
| **Autenticação** | ✅ Bearer Token |

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `title` | string | ✅ | 10–200 caracteres |
| `description` | string | ✅ | 20–2000 caracteres |
| `originalPrice` | number | ✅ | > 0 |
| `dealPrice` | number | ✅ | > 0 e < originalPrice |
| `dealUrl` | string | ✅ | URL válida |
| `store` | string | ✅ | Máx. 100 caracteres |
| `category` | string | ✅ | Enum DealCategory |
| `imageUrl` | string | ❌ | URL válida |
| `couponCode` | string | ❌ | Máx. 50 caracteres |
| `hasFreeShipping` | boolean | ❌ | Padrão: false |
| `expiresAt` | string | ❌ | ISO 8601, data futura |

**Exemplo de Requisição:**
```json
{
  "title": "PlayStation 5 Console Slim + 2 Controles + 3 Jogos",
  "description": "Bundle PS5 Slim com 2 controles DualSense e jogos Spider-Man 2, God of War Ragnarök e FIFA 25.",
  "originalPrice": 4699.00,
  "dealPrice": 3199.00,
  "dealUrl": "https://kabum.com.br/produto/ps5-bundle",
  "store": "Kabum",
  "category": "jogos",
  "imageUrl": "https://cdn.achadosbr.com/images/ps5.png",
  "hasFreeShipping": true,
  "expiresAt": "2026-07-09T23:59:00Z"
}
```

**Resposta de Sucesso — 201 Created:**
```json
{
  "success": true,
  "data": {
    "id": "deal-new-001",
    "title": "PlayStation 5 Console Slim...",
    "dealPrice": 3199.00,
    "originalPrice": 4699.00,
    "discountPercent": 31.9,
    "postedAt": "2026-07-07T19:29:00Z",
    "upvotes": 0,
    "downvotes": 0,
    "isHot": false
  }
}
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 400 | `VALIDATION_ERROR` | Campos inválidos |
| 401 | `UNAUTHORIZED` | Não autenticado |

**Regras de Negócio:**
- `affiliateId` é preenchido automaticamente pelo backend com base no token do usuário autenticado (se for afiliado).
- `postedBy` e `postedById` são preenchidos automaticamente.
- `isVerified` e `isHot` começam como `false`; são controlados por moderação/algoritmo do backend.
- `discountPercent` e `savings` são calculados pelo backend.

---

### EP-17 — Votar em um Deal (Upvote / Downvote)
| Campo | Valor |
|-------|-------|
| **Nome** | Vote Deal |
| **Método** | POST |
| **Rota** | `/deals/{dealId}/vote` |
| **Autenticação** | ✅ Bearer Token |

**Path Params:**
| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| `dealId` | string | ✅ |

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `vote` | string | ✅ | Enum: `up` \| `down` |

**Exemplo de Requisição:**
```json
{ "vote": "up" }
```

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "dealId": "deal-001",
    "upvotes": 843,
    "downvotes": 12,
    "temperature": 831,
    "userVote": "up"
  }
}
```

**Regras de Negócio:**
- Um usuário pode votar apenas uma vez por deal.
- Se votar novamente com o mesmo valor, o voto é removido (toggle).
- Se votar com valor diferente, o voto anterior é substituído.
- O backend deve recalcular `isHot` automaticamente com base no `temperature`.

---

### EP-18 — Buscar Deals (Search)
| Campo | Valor |
|-------|-------|
| **Nome** | Search Deals |
| **Método** | GET |
| **Rota** | `/deals/search` |
| **Autenticação** | Não |

**Query Params:**
| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `q` | string | ✅ | Texto de busca (mínimo 2 caracteres) |
| `category` | string | ❌ | Filtro de categoria |
| `minDiscount` | number | ❌ | Desconto mínimo em % |
| `maxPrice` | number | ❌ | Preço máximo do deal |
| `hasFreeShipping` | boolean | ❌ | Apenas com frete grátis |
| `store` | string | ❌ | Filtrar por loja específica |
| `page` | number | ❌ | Página (padrão: 1) |
| `limit` | number | ❌ | Itens por página (padrão: 20) |

**Resposta de Sucesso — 200 OK:**  
Mesma estrutura do EP-14.

**Regra de Negócio:** A busca deve cobrir `title`, `description`, `store` e `couponCode`.

---

## 8. Endpoints — Afiliados

---

### EP-19 — Listar Afiliados
| Campo | Valor |
|-------|-------|
| **Nome** | List Affiliates |
| **Método** | GET |
| **Rota** | `/affiliates` |
| **Autenticação** | Não |

**Query Params:**
| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| `page` | number | ❌ |
| `limit` | number | ❌ |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "affiliates": [
      {
        "id": "affiliate_tech",
        "name": "TechHunter",
        "bio": "Caçador de ofertas tech...",
        "themeColorHex": "#3B82F6",
        "totalDeals": 128,
        "rating": 4.9,
        "profileImageUrl": null
      }
    ],
    "pagination": { "page": 1, "limit": 20, "total": 6, "totalPages": 1 }
  }
}
```

---

### EP-20 — Obter Perfil Público de Afiliado
| Campo | Valor |
|-------|-------|
| **Nome** | Get Affiliate Profile |
| **Método** | GET |
| **Rota** | `/affiliates/{affiliateId}` |
| **Autenticação** | Não |

**Path Params:**
| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| `affiliateId` | string | ✅ |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "id": "affiliate_tech",
    "userId": "uuid-user-001",
    "name": "TechHunter",
    "displayName": "TechHunter",
    "bio": "Caçador de ofertas tech. Eletrônicos com até 70% de desconto todo dia! 📱💻",
    "themeColorHex": "#3B82F6",
    "totalDeals": 128,
    "rating": 4.9,
    "profileImageUrl": null,
    "bannerUrls": [],
    "createdAt": "2026-01-01T00:00:00Z"
  }
}
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 404 | `AFFILIATE_NOT_FOUND` | Afiliado não encontrado |

---

## 9. Endpoints — Vitrine do Afiliado (AffiliatePage)

---

### EP-21 — Obter Configuração da Vitrine
| Campo | Valor |
|-------|-------|
| **Nome** | Get Affiliate Page |
| **Método** | GET |
| **Rota** | `/affiliates/{affiliateId}/page` |
| **Autenticação** | Não |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "affiliateId": "affiliate_tech",
    "displayName": "TechHunter",
    "bio": "Caçador de ofertas tech...",
    "themeColorHex": "#3B82F6",
    "bannerUrls": ["https://cdn.achadosbr.com/banners/tech1.png"],
    "profileImageUrl": null
  }
}
```

---

### EP-22 — Atualizar Configuração da Vitrine
| Campo | Valor |
|-------|-------|
| **Nome** | Update Affiliate Page |
| **Método** | PUT |
| **Rota** | `/affiliates/{affiliateId}/page` |
| **Autenticação** | ✅ Bearer Token (somente o próprio afiliado) |

**Path Params:**
| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| `affiliateId` | string | ✅ |

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `displayName` | string | ❌ | 2–100 caracteres |
| `bio` | string | ❌ | Máx. 500 caracteres |
| `themeColorHex` | string | ❌ | Hex válido: `#RRGGBB` |
| `bannerUrls` | array[string] | ❌ | URLs válidas, máx. 5 banners |
| `profileImageUrl` | string | ❌ | URL válida |

**Exemplo de Requisição:**
```json
{
  "displayName": "TechHunter Pro",
  "bio": "Eletrônicos com até 70% OFF. Novidades todo dia!",
  "themeColorHex": "#2563EB",
  "bannerUrls": ["https://cdn.achadosbr.com/banners/banner1.png"]
}
```

**Resposta de Sucesso — 200 OK:**  
Retorna o objeto `AffiliatePage` atualizado.

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 401 | `UNAUTHORIZED` | Não autenticado |
| 403 | `FORBIDDEN` | Usuário não é o dono da vitrine |
| 404 | `AFFILIATE_NOT_FOUND` | Afiliado não encontrado |

---

## 10. Endpoints — Produtos do Afiliado (AffiliateProduct)

---

### EP-23 — Listar Produtos do Afiliado
| Campo | Valor |
|-------|-------|
| **Nome** | List Affiliate Products |
| **Método** | GET |
| **Rota** | `/affiliates/{affiliateId}/products` |
| **Autenticação** | Não (produtos ativos) / ✅ Bearer (todos, incluindo inativos — apenas o dono) |

**Query Params:**
| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `activeOnly` | boolean | ❌ | Padrão: `true` para não autenticados |
| `page` | number | ❌ | Padrão: 1 |
| `limit` | number | ❌ | Padrão: 20 |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": "prod-001",
        "affiliateId": "affiliate_tech",
        "title": "Fone JBL Quantum 610 Wireless",
        "description": "Fone gamer sem fio...",
        "price": 349.90,
        "originalPrice": 599.90,
        "discountPercent": 41.67,
        "couponCode": "FONE40",
        "imageUrls": ["https://cdn.achadosbr.com/products/jbl.png"],
        "highlightColor": "#3B82F6",
        "badgePosition": "topLeft",
        "isActive": true,
        "store": "Amazon",
        "storeId": "amazon",
        "category": "eletronicos",
        "hasFreeShipping": true,
        "createdAt": "2026-07-01T10:00:00Z"
      }
    ],
    "pagination": { "page": 1, "limit": 20, "total": 14, "totalPages": 1 }
  }
}
```

---

### EP-24 — Criar Produto do Afiliado
| Campo | Valor |
|-------|-------|
| **Nome** | Create Affiliate Product |
| **Método** | POST |
| **Rota** | `/affiliates/{affiliateId}/products` |
| **Autenticação** | ✅ Bearer Token (somente afiliados, somente o próprio) |

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `title` | string | ✅ | 5–200 caracteres |
| `description` | string | ✅ | 10–2000 caracteres |
| `price` | number | ✅ | > 0 |
| `originalPrice` | number | ✅ | > 0 |
| `discountPercent` | number | ❌ | 0–100; calculado automaticamente se omitido |
| `imageUrls` | array[string] | ✅ | Min. 1 URL, máx. 10 |
| `store` | string | ✅ | Máx. 100 caracteres |
| `storeId` | string | ❌ | ID interno da loja (ex: `amazon`) |
| `category` | string | ✅ | Enum DealCategory |
| `couponCode` | string | ❌ | Máx. 50 caracteres |
| `highlightColor` | string | ❌ | Hex válido; padrão: `#7C3AED` |
| `badgePosition` | string | ❌ | Enum BadgePosition; padrão: `topLeft` |
| `hasFreeShipping` | boolean | ❌ | Padrão: false |
| `isActive` | boolean | ❌ | Padrão: true |

**Enum BadgePosition:** `topLeft` \| `topRight` \| `center` \| `bottomLeft` \| `bottomRight`

**Resposta de Sucesso — 201 Created:**  
Retorna o objeto `AffiliateProduct` criado.

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 400 | `VALIDATION_ERROR` | Campos inválidos |
| 401 | `UNAUTHORIZED` | Não autenticado |
| 403 | `FORBIDDEN` | Não é afiliado ou não é o dono |

---

### EP-25 — Atualizar Produto do Afiliado
| Campo | Valor |
|-------|-------|
| **Nome** | Update Affiliate Product |
| **Método** | PUT |
| **Rota** | `/affiliates/{affiliateId}/products/{productId}` |
| **Autenticação** | ✅ Bearer Token (somente o dono) |

**Body:** Mesmos campos do EP-24, todos opcionais.

**Resposta de Sucesso — 200 OK:**  
Retorna o objeto `AffiliateProduct` atualizado.

---

### EP-26 — Ativar / Desativar Produto (Toggle)
| Campo | Valor |
|-------|-------|
| **Nome** | Toggle Product Active |
| **Método** | PATCH |
| **Rota** | `/affiliates/{affiliateId}/products/{productId}/toggle-active` |
| **Autenticação** | ✅ Bearer Token (somente o dono) |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "productId": "prod-001",
    "isActive": false
  }
}
```

---

### EP-27 — Deletar Produto do Afiliado
| Campo | Valor |
|-------|-------|
| **Nome** | Delete Affiliate Product |
| **Método** | DELETE |
| **Rota** | `/affiliates/{affiliateId}/products/{productId}` |
| **Autenticação** | ✅ Bearer Token (somente o dono) |

**Resposta de Sucesso — 200 OK:**
```json
{ "success": true }
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 403 | `FORBIDDEN` | Não é o dono |
| 404 | `PRODUCT_NOT_FOUND` | Produto não encontrado |

---

## 11. Endpoints — Avaliações (Reviews)

---

### EP-28 — Listar Reviews de um Deal
| Campo | Valor |
|-------|-------|
| **Nome** | List Deal Reviews |
| **Método** | GET |
| **Rota** | `/deals/{dealId}/reviews` |
| **Autenticação** | Não |

**Query Params:**
| Campo | Tipo | Obrigatório |
|-------|------|-------------|
| `page` | number | ❌ |
| `limit` | number | ❌ |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "reviews": [
      {
        "id": "rev-001",
        "dealId": "deal-001",
        "userId": "uuid-user-001",
        "userName": "Carlos M.",
        "userAvatarColor": "#10B981",
        "rating": 5,
        "comment": "Produto incrível! Chegou antes do prazo e embalagem perfeita.",
        "emojiReactions": ["📦", "⚡", "👍"],
        "createdAt": "2026-07-05T12:00:00Z",
        "isVerifiedPurchase": true
      }
    ],
    "summary": {
      "averageRating": 4.67,
      "totalReviews": 3,
      "ratingDistribution": {
        "5": 2,
        "4": 1,
        "3": 0,
        "2": 0,
        "1": 0
      }
    },
    "pagination": { "page": 1, "limit": 20, "total": 3, "totalPages": 1 }
  }
}
```

---

### EP-29 — Criar Review
| Campo | Valor |
|-------|-------|
| **Nome** | Create Review |
| **Método** | POST |
| **Rota** | `/deals/{dealId}/reviews` |
| **Autenticação** | ✅ Bearer Token |

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `rating` | number | ✅ | Inteiro entre 1 e 5 |
| `comment` | string | ✅ | 10–1000 caracteres |
| `emojiReactions` | array[string] | ❌ | Máx. 5 emojis da lista permitida |

**Lista de emojis permitidos:** `📦`, `⚡`, `👍`, `📸`, `❤️`, `🔋`, `🚀`, `⭐`, `🎮`, `🔥`, `👑`, `💼`, `🎵`

**Exemplo de Requisição:**
```json
{
  "rating": 5,
  "comment": "Produto incrível! Chegou antes do prazo e embalagem perfeita. Valeu cada centavo!",
  "emojiReactions": ["📦", "⚡", "👍"]
}
```

**Resposta de Sucesso — 201 Created:**  
Retorna o objeto `Review` criado.

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 400 | `VALIDATION_ERROR` | Campos inválidos |
| 401 | `UNAUTHORIZED` | Não autenticado |
| 409 | `ALREADY_REVIEWED` | Usuário já avaliou este deal |

**Regras de Negócio:**
- Um usuário só pode avaliar cada deal uma vez.
- `userName` e `userAvatarColor` são obtidos automaticamente do perfil autenticado.
- `isVerifiedPurchase` pode ser verificado se o backend tiver integração com o histórico de compras.

---

### EP-30 — Deletar Review
| Campo | Valor |
|-------|-------|
| **Nome** | Delete Review |
| **Método** | DELETE |
| **Rota** | `/deals/{dealId}/reviews/{reviewId}` |
| **Autenticação** | ✅ Bearer Token (somente o autor ou admin) |

**Resposta de Sucesso — 200 OK:**
```json
{ "success": true }
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 403 | `FORBIDDEN` | Não é o autor da review |
| 404 | `REVIEW_NOT_FOUND` | Review não encontrada |

---

## 12. Endpoints — Impulsionamento (Boost)

---

### EP-31 — Listar Planos de Boost
| Campo | Valor |
|-------|-------|
| **Nome** | List Boost Plans |
| **Método** | GET |
| **Rota** | `/boosts/plans` |
| **Autenticação** | Não |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "plans": [
      {
        "plan": "basico",
        "planName": "Básico",
        "planPrice": "R$ 29,90",
        "priceCents": 2990,
        "durationDays": 7,
        "priority": 10,
        "description": "Leve impulso na listagem"
      },
      {
        "plan": "pro",
        "planName": "Pro Destaque",
        "planPrice": "R$ 79,90",
        "priceCents": 7990,
        "durationDays": 30,
        "priority": 50,
        "description": "Destaque na lista por 30 dias"
      },
      {
        "plan": "premium",
        "planName": "Premium TOP",
        "planPrice": "R$ 199,90",
        "priceCents": 19990,
        "durationDays": 30,
        "priority": 100,
        "description": "Topo absoluto da listagem por 30 dias"
      }
    ]
  }
}
```

---

### EP-32 — Contratar Boost para Produto
| Campo | Valor |
|-------|-------|
| **Nome** | Purchase Boost |
| **Método** | POST |
| **Rota** | `/boosts` |
| **Autenticação** | ✅ Bearer Token (somente afiliados) |

**Body:**
| Campo | Tipo | Obrigatório | Validação |
|-------|------|-------------|-----------|
| `productId` | string | ✅ | ID de um AffiliateProduct do próprio afiliado |
| `affiliateId` | string | ✅ | ID do afiliado autenticado |
| `plan` | string | ✅ | Enum: `basico` \| `pro` \| `premium` |
| `paymentToken` | string | ✅ | Token do gateway de pagamento |

**Exemplo de Requisição:**
```json
{
  "productId": "prod-001",
  "affiliateId": "affiliate_tech",
  "plan": "premium",
  "paymentToken": "tok_visa_123abc"
}
```

**Resposta de Sucesso — 201 Created:**
```json
{
  "success": true,
  "data": {
    "id": "boost-001",
    "productId": "prod-001",
    "affiliateId": "affiliate_tech",
    "plan": "premium",
    "planName": "Premium TOP",
    "startDate": "2026-07-07T19:00:00Z",
    "endDate": "2026-08-06T19:00:00Z",
    "isActive": true,
    "priority": 100,
    "durationDays": 30
  }
}
```

**Respostas de Erro:**
| Código | Code | Situação |
|--------|------|----------|
| 400 | `INVALID_PLAN` | Plano inválido |
| 402 | `PAYMENT_FAILED` | Falha no pagamento |
| 403 | `FORBIDDEN` | Usuário não é afiliado ou produto não é seu |
| 404 | `PRODUCT_NOT_FOUND` | Produto não encontrado |

**Regras de Negócio:**
- Um produto com boost ativo tem o boost anterior cancelado ao contratar um novo.
- O backend deve ordenar as listagens de deals e produtos com base na `priority` do boost.
- Prioridades: `premium` = 100, `pro` = 50, `basico` = 10.

---

### EP-33 — Listar Boosts Ativos do Afiliado
| Campo | Valor |
|-------|-------|
| **Nome** | List Affiliate Boosts |
| **Método** | GET |
| **Rota** | `/affiliates/{affiliateId}/boosts` |
| **Autenticação** | ✅ Bearer Token (somente o próprio afiliado) |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "boosts": [
      {
        "id": "boost-001",
        "productId": "prod-001",
        "plan": "premium",
        "startDate": "2026-07-07T19:00:00Z",
        "endDate": "2026-08-06T19:00:00Z",
        "isActive": true,
        "priority": 100
      }
    ]
  }
}
```

---

## 13. Endpoints — Lojas (StoreBrand)

---

### EP-34 — Listar Lojas Cadastradas
| Campo | Valor |
|-------|-------|
| **Nome** | List Stores |
| **Método** | GET |
| **Rota** | `/stores` |
| **Autenticação** | Não |

**Resposta de Sucesso — 200 OK:**
```json
{
  "success": true,
  "data": {
    "stores": [
      {
        "id": "amazon",
        "name": "Amazon",
        "primaryColor": "#FF9900",
        "textColor": "#000000",
        "logoUrl": "https://cdn.achadosbr.com/stores/amazon.png"
      },
      {
        "id": "kabum",
        "name": "Kabum",
        "primaryColor": "#FC6B0F",
        "textColor": "#FFFFFF",
        "logoUrl": "https://cdn.achadosbr.com/stores/kabum.png"
      }
    ]
  }
}
```

**Lojas suportadas:** `amazon`, `magalu`, `americanas`, `kabum`, `shopee`, `mercadolivre`, `casasbahia`, `aliexpress`, `submarino`, `pontofrio`, `shein`, `nike`, `adidas`, `leroymerlin`, `madeiramadeira`, `epocacosmeticos`, `outros`.

---

## 14. Fluxo de Dados entre Frontend e Backend

### 14.1 Tela de Login/Registro
```
Frontend → POST /auth/register { name, email, password, userType }
Backend  → { user, accessToken, refreshToken }
Frontend → Armazena tokens (Secure Storage), perfil em memória
```

### 14.2 Tela Home (Feed de Deals)
```
Frontend → GET /deals?sortBy=hot&limit=20
Backend  → { deals[], pagination }
Frontend → GET /deals?sortBy=hot&affiliateId=XXX (opcional por afiliado)
```

### 14.3 Tela de Detalhe do Deal
```
Frontend → GET /deals/{dealId}
Backend  → { deal completo }
Frontend → GET /deals/{dealId}/reviews
Backend  → { reviews[], summary }
Frontend → POST /deals/{dealId}/vote { vote: "up" }    [autenticado]
Backend  → { upvotes, downvotes, temperature, userVote }
Frontend → POST /users/me/saved-deals/{dealId}         [autenticado]
Frontend → POST /users/me/visit-history { dealId, title, imageUrl }
```

### 14.4 Vitrine do Afiliado
```
Frontend → GET /affiliates/{affiliateId}
Backend  → { perfil público do afiliado }
Frontend → GET /affiliates/{affiliateId}/page
Backend  → { configuração da vitrine }
Frontend → GET /affiliates/{affiliateId}/products?activeOnly=true
Backend  → { products[] }
Frontend → GET /deals?affiliateId={affiliateId}
Backend  → { deals publicados pelo afiliado }
```

### 14.5 Gestão de Produtos (Afiliado)
```
Frontend → POST /affiliates/{id}/products { dados do produto }
Backend  → { produto criado }
Frontend → PUT  /affiliates/{id}/products/{prodId} { campos atualizados }
Frontend → PATCH /affiliates/{id}/products/{prodId}/toggle-active
Frontend → DELETE /affiliates/{id}/products/{prodId}
```

### 14.6 Impulsionamento (Boost)
```
Frontend → GET /boosts/plans
Backend  → { planos disponíveis com preços }
Frontend → POST /boosts { productId, affiliateId, plan, paymentToken }
Backend  → { boost criado }
Frontend → GET /affiliates/{id}/boosts
Backend  → { boosts ativos do afiliado }
```

---

## 15. Dependências entre Endpoints

```
EP-02 (Login) ──────────────── Prerequisito para todos os endpoints autenticados
EP-01 (Register) ───────────── Prerequisito para EP-02
EP-21 (Get Page) ───────────── Prerequisito: Afiliado criado (EP-01 com userType=afiliado)
EP-23 (List Products) ──────── Prerequisito: Afiliado criado
EP-24 (Create Product) ─────── Prerequisito: Usuário autenticado como afiliado
EP-32 (Purchase Boost) ─────── Prerequisito: EP-24 (produto deve existir)
EP-29 (Create Review) ──────── Prerequisito: EP-15 (deal deve existir)
EP-17 (Vote) ───────────────── Prerequisito: EP-15 (deal deve existir)
EP-10 (Save Deal) ──────────── Prerequisito: EP-15 (deal deve existir)
EP-11 (Add Visit) ──────────── Prerequisito: EP-15 (deal deve existir)
EP-30 (Delete Review) ──────── Prerequisito: EP-29 (review deve existir)
```

---

## 16. Códigos HTTP Utilizados

| Código | Significado | Situações |
|--------|-------------|-----------|
| 200 | OK | Consultas e atualizações com sucesso |
| 201 | Created | Criação de recurso com sucesso |
| 400 | Bad Request | Validação de campos falhou |
| 401 | Unauthorized | Token ausente, inválido ou expirado |
| 402 | Payment Required | Falha em pagamento de boost |
| 403 | Forbidden | Autenticado, mas sem permissão |
| 404 | Not Found | Recurso não encontrado |
| 409 | Conflict | Duplicata (e-mail já existe, já avaliou) |
| 500 | Server Error | Erro interno inesperado |

---

## 17. Enums e Constantes

### DealCategory
| Valor | Label |
|-------|-------|
| `eletronicos` | Eletrônicos |
| `moda` | Moda |
| `casa` | Casa |
| `beleza` | Beleza |
| `alimentacao` | Alimentação |
| `jogos` | Jogos |
| `esporte` | Esporte |
| `livros` | Livros |
| `viagem` | Viagem |
| `outros` | Outros |

### BadgePosition
| Valor | Posição |
|-------|---------|
| `topLeft` | Superior Esq. |
| `topRight` | Superior Dir. |
| `center` | Centro |
| `bottomLeft` | Inferior Esq. |
| `bottomRight` | Inferior Dir. |

### BoostPlan
| Valor | Nome | Preço | Duração | Prioridade |
|-------|------|-------|---------|------------|
| `basico` | Básico | R$ 29,90 | 7 dias | 10 |
| `pro` | Pro Destaque | R$ 79,90 | 30 dias | 50 |
| `premium` | Premium TOP | R$ 199,90 | 30 dias | 100 |

### UserType
| Valor | Descrição |
|-------|-----------|
| `cliente` | Usuário comum |
| `afiliado` | Afiliado com vitrine e produtos |

---

## 18. Regras Gerais de Validação

| Regra | Aplicação |
|-------|-----------|
| E-mail único | `POST /auth/register` |
| Senha mínima 6 caracteres | `POST /auth/register`, `POST /auth/reset-password` |
| `dealPrice` < `originalPrice` | `POST /deals` |
| Rating entre 1 e 5 | `POST /deals/{id}/reviews` |
| Um review por usuário por deal | `POST /deals/{id}/reviews` |
| Um voto por usuário por deal | `POST /deals/{id}/vote` |
| Máx. 50 itens no histórico | `POST /users/me/visit-history` |
| Máx. 5 banners na vitrine | `PUT /affiliates/{id}/page` |
| Máx. 10 imagens por produto | `POST /affiliates/{id}/products` |
| Hex válido (`#RRGGBB`) | `avatarColor`, `themeColorHex`, `highlightColor` |
| Boost ativo cancelado ao novo boost | `POST /boosts` |

---

*Relatório gerado com base no código-fonte do frontend Flutter (AchadosBR). Todos os contratos de API foram derivados dos modelos, serviços e telas da aplicação mobile.*
