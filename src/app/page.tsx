const sections = [
  { title: "Legislação", description: "Consulte normas e documentos oficiais da simulação." },
  { title: "Editais", description: "Acompanhe seleções, inscrições e resultados." },
  { title: "Comunicados", description: "Veja avisos e atualizações da comunidade." },
  { title: "Jurisprudência", description: "Consulte decisões fictícias produzidas na simulação." }
];

export default function HomePage() {
  return (
    <main className="page">
      <header className="topbar">
        <div className="brand-mark">CJS</div>
        <div>
          <p className="eyebrow">PORTAL INSTITUCIONAL</p>
          <strong>Comando Jurídico Supremo</strong>
        </div>
        <a className="login-link" href="/login">Entrar</a>
      </header>

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
        <div className="section-heading">
          <p className="eyebrow gold">CENTRAL CJS</p>
          <h2>Explore o portal</h2>
        </div>
        <div className="cards">
          {sections.map((section) => (
            <article className="card" key={section.title}>
              <h3>{section.title}</h3>
              <p>{section.description}</p>
            </article>
          ))}
        </div>
      </section>

      <aside className="notice">
        <strong>Importante</strong>
        <p>O CJS é um ambiente de roleplay/simulação. O conteúdo jurídico deste portal é fictício e não substitui orientação profissional.</p>
      </aside>
      <footer>© {new Date().getFullYear()} Comando Jurídico Supremo · CJS</footer>
    </main>
  );
}
