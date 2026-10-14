# CJS — estado de implementação

## Criado no repositório
- Portal público com identidade visual navy/dourado.
- Catálogo de áreas com busca e filtros.
- Páginas-base de legislação, editais, comunicados, jurisprudência, hierarquia, cursos, login, privacidade e painel.
- Documentação da hierarquia informada pela comunidade.
- Esquema SQL inicial e migração de base de dados com tabelas para membros, permissões, documentos, cursos, tickets, notificações, financeiro e auditoria.
- Políticas RLS de negação por padrão para tabelas administrativas, com leitura pública restrita a conteúdo publicado.

## Ainda necessário antes de produção
- Configurar Supabase e aplicar migration em projeto real.
- Configurar Discord OAuth com redirect URI correto.
- Implementar callback OAuth, sessão, sincronização de perfil e logout.
- Implementar camada server-side para permissões e ações administrativas.
- Criar fluxos CRUD reais para documentos, editais, departamentos, cargos, cursos, tickets e financeiro.
- Criar funções confiáveis para auditoria append-only e aprovações de duas pessoas.
- Implementar notificações Discord/e-mail e tarefas de backup.
- Testar build, migrations, RLS, rotas, formulários e acessos negativos.
- Verificar implantação Vercel após configuração.

Não cadastrar dados reais nem usar para decisões reais antes de revisão de segurança.
