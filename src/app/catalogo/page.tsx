"use client";
import { useMemo, useState } from "react";
const items=[
{title:"Legislação e regulamentos",category:"Documentos",description:"Normas institucionais aprovadas e versões vigentes.",href:"/legislacao",status:"Acervo"},
{title:"Editais e seleções",category:"Oportunidades",description:"Processos seletivos, requisitos, prazos e resultados.",href:"/editais",status:"Editais"},
{title:"Comunicados oficiais",category:"Notícias",description:"Avisos e atualizações publicados pela administração autorizada.",href:"/comunicados",status:"Comunicados"},
{title:"Jurisprudência simulada",category:"Documentos",description:"Decisões fictícias dos órgãos do universo CJS.",href:"/jurisprudencia",status:"Decisões"},
{title:"Estrutura e hierarquia",category:"Institucional",description:"Grupos, órgãos e cargos previstos para a comunidade.",href:"/hierarquia",status:"Organização"},
{title:"Cursos e avaliações",category:"Formação",description:"Trilhas de aprendizagem, provas e histórico de conclusão.",href:"/cursos",status:"Formação"},
{title:"Entrar no portal",category:"Acesso",description:"Informações sobre autenticação e acesso institucional.",href:"/login",status:"Acesso"},
{title:"Painel administrativo",category:"Gestão",description:"Prévia dos módulos administrativos planejados; operações desativadas até configuração segura.",href:"/admin",status:"Gestão"},
{title:"Privacidade e segurança",category:"Institucional",description:"Princípios de proteção de dados e estado das integrações.",href:"/privacidade",status:"Transparência"}
];
const categories=["Tudo","Documentos","Oportunidades","Notícias","Institucional","Formação","Acesso","Gestão"];
export default function CatalogoPage(){
 const [category,setCategory]=useState("Tudo"); const [query,setQuery]=useState("");
 const filtered=useMemo(()=>items.filter(x=>(category==="Tudo"||x.category===category)&&((x.title+" "+x.description+" "+x.category).toLowerCase().includes(query.toLowerCase()))),[category,query]);
 return <main className="subpage"><a className="back" href="/">← Voltar ao portal</a><p className="eyebrow gold">CENTRAL DE CONTEÚDO</p><h1>Explore o CJS</h1><p className="intro">Encontre cada área do portal por categoria ou pesquise pelo que precisa.</p>
 <label className="search-label" htmlFor="catalog-search">Pesquisar no portal</label><input id="catalog-search" className="catalog-search" value={query} onChange={e=>setQuery(e.target.value)} placeholder="Ex.: editais, cargos, cursos..." />
 <div className="category-filters" aria-label="Filtrar categorias">{categories.map(c=><button type="button" key={c} onClick={()=>setCategory(c)} className={category===c?"filter-chip active":"filter-chip"} aria-pressed={category===c}>{c}</button>)}</div>
 <p className="results-count">{filtered.length} {filtered.length===1?"área encontrada":"áreas encontradas"}</p>
 <div className="cards catalog-cards">{filtered.map(item=><article className="card" key={item.href}><span className="status">{item.category}</span><h3>{item.title}</h3><p>{item.description}</p><a className="card-link" href={item.href}>Abrir seção ↗</a></article>)}</div>
 {filtered.length===0&&<section className="panel"><h2>Nenhum resultado</h2><p>Tente outro termo ou selecione a categoria “Tudo”.</p><button className="button secondary" onClick={()=>{setQuery("");setCategory("Tudo")}}>Limpar filtros</button></section>}
 <aside className="notice"><strong>Nota sobre o conteúdo</strong><p>O CJS é uma simulação comunitária. Documentos e decisões fictícias não substituem leis reais nem aconselhamento jurídico. Recursos administrativos e autenticação ainda exigem configuração técnica antes do uso real.</p></aside></main>
}
