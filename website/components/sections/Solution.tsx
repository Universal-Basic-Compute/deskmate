"use client";

import { motion } from 'framer-motion';
import Image from 'next/image';
import LightCone from '../ui/LightCone';
import GradientText from '../ui/GradientText';

export default function Solution() {
  return (
    <section id="solution" className="py-20 relative">
      <LightCone
        color="#FFD100"
        intensity={0.1}
        effect="shifting"
        className="absolute inset-0"
      >
        <div></div>
      </LightCone>
      
      <div className="container mx-auto px-4 relative z-10">
        <div className="max-w-3xl mx-auto text-center mb-16">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-6">
              Our <GradientText>Solution</GradientText>
            </h2>
            <p className="text-xl text-gray-300">
              DeskMate combines physical presence with AI intelligence to create a truly interactive learning experience.
            </p>
          </motion.div>
        </div>

        <div className="flex flex-col md:flex-row items-center">
          <motion.div
            className="md:w-1/2 mb-10 md:mb-0 md:pr-10"
            initial={{ opacity: 0, x: -30 }}
            whileInView={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <div className="relative">
              <div className="absolute inset-0 bg-gradient-to-r from-yellow-400/20 to-orange-500/20 rounded-xl blur-xl" />
              <Image 
                src="/images/solution-lamp.png" 
                alt="DeskMate Smart Lamp" 
                width={500}
                height={300}
                className="relative z-10 rounded-xl shadow-2xl"
              />
            </div>
          </motion.div>
          
          <motion.div
            className="md:w-1/2"
            initial={{ opacity: 0, x: 30 }}
            whileInView={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            viewport={{ once: true }}
          >
            <h3 className="text-2xl font-bold mb-6">
              Not Just Another AI Tool
            </h3>
            
            <div className="space-y-6">
              {[
                {
                  title: "Physical Presence",
                  description: "A smart desk lamp that brings AI into your physical study space."
                },
                {
                  title: "Guided Discovery",
                  description: "Instead of giving answers, DeskMate guides you to discover solutions yourself."
                },
                {
                  title: "Adaptive Learning",
                  description: "Personalizes its approach based on your learning style and preferences."
                },
                {
                  title: "Focus Enhancement",
                  description: "Light patterns and timers designed to improve concentration and productivity."
                }
              ].map((item, index) => (
                <div key={index} className="flex">
                  <div className="flex-shrink-0 h-6 w-6 rounded-full bg-gradient-to-r from-yellow-400 to-orange-500 flex items-center justify-center mt-1">
                    <span className="text-gray-900 text-sm font-bold">{index + 1}</span>
                  </div>
                  <div className="ml-4">
                    <h4 className="text-lg font-semibold">{item.title}</h4>
                    <p className="text-gray-300">{item.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
}
