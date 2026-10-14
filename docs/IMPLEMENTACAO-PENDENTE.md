# CJS — estado de implementação

## Criado no repositório
- Portal público com identidade visual navy/dourado e páginas institucionais.
- Catálogo de áreas com busca e filtros.
- Hierarquia institucional documentada e página de consulta.
- Esquema SQL inicial para membros, permissões, documentos e versões, cursos, tickets, notificações, financeiro e auditoria.
- Políticas RLS iniciais; leitura pública restrita a conteúdo publicado.
- Cliente Supabase para navegador/servidor.
- Fluxo inicial de login Discord via Supabase Auth e callback OAuth (depende de configuração externa).

## Dependências externas que o proprietário precisa configurar
1. Criar projeto Supabase e aplicar `supabase/migrations/20261014_cjs_core.sql` pelo SQL Editor, após revisar que o projeto está vazio e sem tabelas conflitantes.
2. No Supabase Auth, ativar o provedor Discord e inserir Client ID/Secret obtidos no Discord Developer Portal.
3. Configurar a URL do site e URLs de redirecionamento autorizadas, incluindo `https://SEU-DOMINIO/auth/callback` e a URL de preview/desenvolvimento que realmente será usada.
4. Configurar no Vercel `NEXT_PUBLIC_SUPABASE_URL` e `NEXT_PUBLIC_SUPABASE_ANON_KEY`. Nunca expor `SUPABASE_SERVICE_ROLE_KEY` no navegador ou em repositório.
5. Fazer deploy e testar o login após configurar provedor e variáveis.

## Ainda necessário antes de produção
- Testar build e corrigir eventuais erros de TypeScript/Next.js.
- Implementar logout e telas de sessão/perfil.
- Implementar autorização server-side e papéis institucionais reais; nunca confiar em e-mail/nome do Discord para conceder Fundador.
- Implementar operações administrativas CRUD com validação e permissões no servidor.
- Rever RLS tabela por tabela, especialmente escrita, tickets privados e dados financeiros.
- Criar funções seguras para auditoria append-only e aprovações de duas pessoas.
- Criar notificações Discord/e-mail e rotina de backup com teste de restauração.
- Testar rotas, formulários, migrations e tentativas de acesso não autorizado.

## Segurança
O painel administrativo ainda é uma estrutura visual, não uma ferramenta operacional. Não cadastrar dados sensíveis nem usar para decisões reais antes de revisão de segurança. Leis, editais e jurisprudência do portal são materiais fictícios de simulação, não orientação jurídica real.
