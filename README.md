# Rifa 2º Alimentos — Pix manual com análise de comprovante

Projeto React + Vite + Supabase. O pagamento é feito fora do site por Pix; o comprador envia o comprovante e o administrador confere o crédito no banco antes de aprovar as cotas. **O comprovante não é prova de pagamento por si só.**

## Funcionalidades
- Página pública para listar rifas ativas.
- Seleção de números/cotas e cálculo automático do total.
- Reserva por 5 minutos no banco de dados; o servidor bloqueia cotas já pagas ou reservadas em pedidos ainda válidos.
- Chave Pix, recebedor e banco configuráveis no painel.
- Envio de comprovante em imagem ou PDF.
- Login de administrador restrito ao e-mail `ifroalimentos.25@gmail.com`.
- Painel para revisar pedidos, ver comprovantes em link temporário, confirmar pagamento ou marcar pagamento não concluído.
- Criar/editar/encerrar rifas e enviar imagem do prêmio.
- Configurações de site e e-mail de suporte.

## 1. Criar o projeto Supabase
1. Acesse https://supabase.com e crie um projeto.
2. Abra **SQL Editor → New query**.
3. Cole o conteúdo de `supabase/schema.sql` e execute.
4. Em **Authentication → Users**, crie o usuário `ifroalimentos.25@gmail.com` com uma senha forte. Use a opção de confirmar usuário, se disponível.
5. Em **Project Settings → API** (ou Connect), copie a Project URL e a chave pública/anon (publishable). Não use `service_role` no site.

## 2. Configurar localmente
Instale Node.js LTS: https://nodejs.org

Na pasta do projeto, copie `.env.example` para `.env` e preencha:

```env
VITE_SUPABASE_URL=https://SEU-PROJETO.supabase.co
VITE_SUPABASE_ANON_KEY=SUA_CHAVE_PUBLICA
```

No terminal:

```bash
npm install
npm run dev
```

Abra o endereço local mostrado pelo Vite. Para gerar a versão de publicação:

```bash
npm run build
```

## 3. Publicar no GitHub Pages
O jeito mais simples para Vite em GitHub Pages é usar o workflow abaixo e configurar a variável `VITE_SUPABASE_URL` e o segredo `VITE_SUPABASE_ANON_KEY` em **Settings → Secrets and variables → Actions**. O workflow publica o conteúdo de `dist/`.

> Para sites com rifas e dinheiro, recomendo domínio próprio e revisão técnica antes de abrir ao público. GitHub Pages serve arquivos estáticos; Supabase é que fornece banco, autenticação e armazenamento.

## 4. Fluxo de pagamento
1. O comprador escolhe cotas e preenche nome/e-mail.
2. A função SQL `create_reservation` valida e reserva os números por cinco minutos.
3. O comprador faz o Pix para a chave mostrada e envia comprovante antes do vencimento.
4. O administrador verifica no aplicativo do banco se o valor realmente caiu.
5. Só então seleciona **Confirmar pagamento**. Caso não tenha caído, marca **Pagamento não concluído**.

O tempo de cinco minutos é para criar a reserva e enviar o comprovante. Depois do envio, o pedido fica aguardando análise; cotas pendentes de análise continuam bloqueadas até o administrador decidir. Isso evita que o prazo expire durante a revisão. Se for necessário liberar cotas rejeitadas imediatamente, configure essa regra com cuidado.

## Segurança importante
- Nunca coloque Access Token, service-role key, senha do banco ou outras chaves privadas no frontend/GitHub.
- A chave Pix é pública por natureza, mas confirme nome e banco antes de publicar.
- A aprovação deve ocorrer somente após conferir o extrato do banco, nunca apenas pela imagem enviada.
- O sistema não integra API bancária nem confirma Pix automaticamente.
- Verifique com o provedor de pagamentos e com orientação jurídica se a atividade de rifa/sorteio está autorizada antes de receber valores. Não publique uma rifa sem confirmar as regras aplicáveis.

## Limitações a testar antes do lançamento
- Testar reservas simultâneas e upload de comprovante.
- Testar a criação de rifas, upload de imagens e aprovação/rejeição de pedidos.
- Confirmar a configuração de e-mail de suporte e os textos/regras da rifa.
- O painel nesta versão não oferece recuperação automática de senha por e-mail nem notificações automáticas ao comprador.

## Arquivos ocultos no Android
Alguns gerenciadores Android escondem arquivos e pastas cujo nome começa com ponto. Por isso, `.env.example`, `.gitignore` e `.github` podem não aparecer na listagem normal, mas estão no ZIP. Ative “Mostrar arquivos ocultos” no gerenciador, se disponível. Ao subir os arquivos para o GitHub, mantenha `.github/workflows/deploy.yml` na raiz do repositório.

## Nota de prontidão
Este pacote é uma base de projeto que ainda exige configuração no Supabase e testes reais de permissões, reservas simultâneas, upload e revisão de comprovantes antes de receber pedidos públicos. A versão não faz confirmação bancária automática.
