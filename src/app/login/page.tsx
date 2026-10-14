"use client";

import { useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase-browser";

export default function LoginPage() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  async function loginWithDiscord() {
    setError("");
    setLoading(true);
    try {
      const supabase = createSupabaseBrowserClient();
      const { error: authError } = await supabase.auth.signInWithOAuth({
        provider: "discord",
        options: { redirectTo: `${window.location.origin}/auth/callback?next=/` },
      });
      if (authError) throw authError;
    } catch (e) {
      setError(e instanceof Error ? e.message : "Não foi possível iniciar o acesso.");
      setLoading(false);
    }
  }

  return <main className="subpage">
    <a className="back" href="/">← Voltar ao portal</a>
    <p className="eyebrow gold">ACESSO INSTITUCIONAL</p>
    <h1>Entrar no CJS</h1>
    <p className="intro">Entre usando sua conta Discord. O acesso a áreas internas depende de autorização institucional separada.</p>
    <section className="panel">
      <h2>Entrada por Discord</h2>
      <p>Você será redirecionado ao Discord para autorizar a autenticação. O portal nunca pede sua senha do Discord diretamente.</p>
      <button className="button primary" onClick={loginWithDiscord} disabled={loading}>
        {loading ? "Conectando…" : "Continuar com Discord"}
      </button>
      {error && <p role="alert" className="small-note">{error} Confira se as variáveis do Supabase estão configuradas e se o provedor Discord está ativado.</p>}
    </section>
    <p className="small-note">Entrar não concede automaticamente cargo de Fundador, patente, departamento nem permissão administrativa. Essas autorizações devem ser validadas no servidor.</p>
  </main>;
}
