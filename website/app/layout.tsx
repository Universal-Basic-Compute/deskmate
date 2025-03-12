import '../styles/globals.css';
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'DeskMate | AI Study Companion',
  description: 'DeskMate combines a smart desk lamp with AI tutoring to help students solve problems through guided discovery, not just answers.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-background-grey text-white">{children}</body>
    </html>
  );
}
