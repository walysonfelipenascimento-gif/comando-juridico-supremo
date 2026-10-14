import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Comando Jurídico Supremo | CJS",
  description: "Portal oficial da comunidade de simulação jurídica CJS."
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  );
}
