import Head from 'next/head';

type SEOProps = {
  title: string;
  description: string;
  canonical?: string;
  ogImage?: string;
};

export default function SEO({ 
  title, 
  description, 
  canonical = 'https://deskmate.ai', 
  ogImage = '/images/og-image.jpg' 
}: SEOProps) {
  return (
    <Head>
      <title>{title}</title>
      <meta name="description" content={description} />
      <link rel="canonical" href={canonical} />
      <link rel="icon" href="/logo.svg" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      
      {/* Open Graph / Facebook */}
      <meta property="og:type" content="website" />
      <meta property="og:url" content={canonical} />
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={ogImage} />
      
      {/* Twitter */}
      <meta property="twitter:card" content="summary_large_image" />
      <meta property="twitter:url" content={canonical} />
      <meta property="twitter:title" content={title} />
      <meta property="twitter:description" content={description} />
      <meta property="twitter:image" content={ogImage} />
    </Head>
  );
}
