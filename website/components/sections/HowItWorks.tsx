"use client";

import { motion } from 'framer-motion';
import Image from 'next/image';
import LightCone from '../ui/LightCone';
import GradientText from '../ui/GradientText';

export default function HowItWorks() {
  const steps = [
    {
      title: "Set Up Your DeskMate",
      description: "Place your DeskMate lamp on your desk and connect it to your WiFi network.",
      icon: "📡"
    },
    {
      title: "Personalize Your Experience",
      description: "Complete a quick assessment to customize DeskMate to your learning style.",
      icon: "👤"
    },
    {
      title: "Start a Study Session",
      description: "Set your study goals and duration, then begin your focused work.",
      icon: "🎯"
    },
    {
      title: "Get Real-time Assistance",
      description: "Ask questions by voice or text whenever you need help with your material.",
      icon: "💬"
    }
  ];

  return (
    <section id="how-it-works" className="py-20 relative">
      <LightCone
        color="#9C27B0"
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
              How <GradientText from="#9C27B0" to="#E040FB">DeskMate</GradientText> Works
            </h2>
            <p className="text-xl text-gray-300">
              Getting started with DeskMate is simple and intuitive.
            </p>
          </motion.div>
        </div>

        <div className="relative">
          {/* Connecting line */}
          <div className="absolute left-1/2 top-0 bottom-0 w-1 bg-gradient-to-b from-violet-700 to-violet-500 hidden md:block" style={{ transform: 'translateX(-50%)' }}></div>
          
          <div className="space-y-24">
            {steps.map((step, index) => (
              <div key={index} className="relative">
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.6, delay: index * 0.2 }}
                  viewport={{ once: true }}
                  className="flex flex-col md:flex-row items-center"
                >
                  <div className={`md:w-1/2 ${index % 2 === 0 ? 'md:pr-16 md:text-right' : 'md:pl-16 md:order-last'}`}>
                    <h3 className="text-2xl font-bold mb-4">{step.title}</h3>
                    <p className="text-gray-300 text-lg">{step.description}</p>
                  </div>
                  
                  <div className="md:w-0 flex justify-center my-8 md:my-0">
                    <div className="w-16 h-16 rounded-full bg-violet-700 flex items-center justify-center text-2xl z-10">
                      {step.icon}
                    </div>
                  </div>
                  
                  <div className={`md:w-1/2 ${index % 2 === 0 ? 'md:pl-16 md:order-last' : 'md:pr-16'}`}>
                    {index % 2 === 0 ? (
                      <div className="relative">
                        <div className="absolute inset-0 bg-gradient-to-r from-violet-500/20 to-fuchsia-500/20 rounded-xl blur-xl" />
                        <Image 
                          src={`/images/step-${index + 1}.png`} 
                          alt={step.title}
                          width={600}
                          height={400}
                          className="relative z-10 rounded-xl shadow-2xl w-full"
                        />
                      </div>
                    ) : (
                      <div className="relative">
                        <div className="absolute inset-0 bg-gradient-to-r from-violet-500/20 to-fuchsia-500/20 rounded-xl blur-xl" />
                        <Image 
                          src={`/images/step-${index + 1}.png`} 
                          alt={step.title}
                          width={600}
                          height={400}
                          className="relative z-10 rounded-xl shadow-2xl w-full"
                        />
                      </div>
                    )}
                  </div>
                </motion.div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
