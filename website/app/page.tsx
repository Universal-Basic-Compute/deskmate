import React from 'react';
import Layout from '../components/Layout';
import Hero from '../components/sections/Hero';
import Features from '../components/sections/Features';
import Solution from '../components/sections/Solution';
import HowItWorks from '../components/sections/HowItWorks';
import Pricing from '../components/sections/Pricing';
import BetaProgram from '../components/sections/BetaProgram';
import FAQ from '../components/sections/FAQ';

export const metadata = {
  title: "DeskMate | AI Study Companion",
  description: "DeskMate combines a smart desk lamp with AI tutoring to help students solve problems through guided discovery, not just answers."
};

export default function Home() {
  return (
    <Layout>
      <Hero />
      <Features />
      <Solution />
      <HowItWorks />
      <Pricing />
      <BetaProgram />
      <FAQ />
    </Layout>
  );
}
