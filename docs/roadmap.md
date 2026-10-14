# Roteiro de implementação do portal CJS

## Base entregue ao repositório
- [x] Estrutura inicial Next.js e TypeScript
- [x] Página institucional responsiva
- [x] Páginas-base para legislação, editais, comunicados e jurisprudência
- [x] Aviso de que o conteúdo jurídico é ficcional
- [x] Esboço de privacidade e painel administrativo desabilitado
- [x] Rascunho inicial do esquema de dados e hierarquia

## Antes de produção
- [ ] Confirmar domínio, projeto e deploy na Vercel
- [ ] Configurar projeto Supabase e aplicar schema revisado
- [ ] Implementar autenticação Discord OAuth e validar callback/estado
- [ ] Definir RBAC e políticas RLS com testes negativos
- [ ] Criar fluxo de pedidos de ingresso e aprovação por autoridade
- [ ] Implementar publicação com estados, versões, vigência e classificação
- [ ] Implementar auditoria append-only no servidor
- [ ] Criar cursos, avaliações, tickets, notificações e relatórios
- [ ] Adicionar testes automatizados, monitoramento e backups
- [ ] Revisão de segurança e privacidade antes de armazenar dados reais

Não usar este projeto como sistema de produção até concluir e testar os itens acima.
