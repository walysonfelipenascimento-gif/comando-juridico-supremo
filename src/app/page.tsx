const sections = [
  { title: "Legislação", description: "Normas e documentos aprovados da simulação.", href: "/legislacao", label: "Abrir acervo" },
  { title: "Editais", description: "Seleções, inscrições, requisitos e resultados.", href: "/editais", label: "Consultar editais" },
  { title: "Comunicados", description: "Avisos e atualizações institucionais.", href: "/comunicados", label: "Ler comunicados" },
  { title: "Jurisprudência", description: "Decisões fictícias produzidas na simulação.", href: "/jurisprudencia", label: "Consultar decisões" },
  { title: "Cursos", description: "Área planejada para formação e avaliações.", href: "/cursos", label: "Ver cursos" },
  { title: "Hierarquia", description: "Estrutura institucional informada pela comunidade.", href: "/hierarquia", label: "Ver estrutura" },
  { title: "Privacidade", description: "Informações sobre segurança e dados.", href: "/privacidade", label: "Ler informações" },
  { title: "Área administrativa", description: "Prévia dos módulos de gestão, ainda desativados.", href: "/admin", label: "Ver painel" }
];

export default function HomePage() {
  return (
    <main className="page">
      <header className="topbar">
        <a className="brand-mark" href="/" aria-label="Página inicial CJS">CJS</a>
        <div className="brand-copy">
          <p className="eyebrow">PORTAL INSTITUCIONAL</p>
          <strong>Comando Jurídico Supremo</strong>
        </div>
        <a className="login-link" href="/login">Entrar</a>
      </header>

      <nav className="site-nav" aria-label="Navegação principal">
        <a href="/legislacao">Legislação</a><a href="/editais">Editais</a><a href="/comunicados">Comunicados</a><a href="/jurisprudencia">Jurisprudência</a><a href="/hierarquia">Hierarquia</a>
      </nav>

      <section className="hero">
        <p className="eyebrow gold">ORDEM • JUSTIÇA • RESPONSABILIDADE</p>
        <h1>Um espaço de organização para a simulação jurídica.</h1>
        <p className="intro">Documentos, editais, comunicados e informações institucionais da comunidade CJS em um só lugar.</p>
        <div className="hero-actions">
          <a className="button primary" href="/legislacao">Consultar documentos</a>
          <a className="button secondary" href="/editais">Ver editais</a>
        </div>
      </section>

      <section className="section">
        <div className="section-heading"><p className="eyebrow gold">CENTRAL CJS</p><h2>Explore o portal</h2></div>
        <div className="cards">
          {sections.map((section) => <article className="card" key={section.title}>
            <h3>{section.title}</h3><p>{section.description}</p><a className="card-link" href={section.href}>{section.label} ↗</a>
          </article>)}
        </div>
      </section>

      <aside className="notice"><strong>Importante — ambiente de simulação</strong><p>O CJS é um ambiente de roleplay. Leis, documentos, editais e decisões deste portal são fictícios e não constituem orientação jurídica real.</p></aside>
      <footer><span>© {new Date().getFullYear()} Comando Jurídico Supremo · CJS</span><a href="/privacidade">Privacidade e segurança</a></footer>
    </main>
  );
}
