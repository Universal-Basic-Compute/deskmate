"use client";

import { motion } from 'framer-motion';
import LightCone from '../ui/LightCone';
import GradientText from '../ui/GradientText';
import Button from '../ui/Button';
import { useState } from 'react';

export default function Pricing() {
  const [isAnnual, setIsAnnual] = useState(true);
  
  const plans = [
    {
      name: "Free",
      description: "Basic features with usage limits",
      price: 0,
      features: [
        "AI Study Assistant (10 questions/day)",
        "Basic Focus Monitoring",
        "Session Timer",
        "Limited Analytics"
      ],
      color: "#4CAF50",
      popular: false
    },
    {
      name: "Student",
      description: "Full access with student verification",
      price: isAnnual ? 14.97 : 20.97,
      features: [
        "Unlimited AI Assistance",
        "Advanced Focus Monitoring",
        "Comprehensive Analytics",
        "Learning Style Adaptation",
        "Resource Suggestions",
        "Priority Support"
      ],
      color: "#FFD100",
      popular: true
    },
    {
      name: "Premium",
      description: "Complete features for all users",
      price: isAnnual ? 29.97 : 38.97,
      features: [
        "Everything in Student Plan",
        "Multiple Study Profiles",
        "Advanced Customization",
        "API Access",
        "Early Access to New Features",
        "24/7 Premium Support"
      ],
      color: "#9C27B0",
      popular: false
    }
  ];

  return (
    <section id="pricing" className="py-20">
      <div className="container mx-auto px-4">
        <div className="max-w-3xl mx-auto text-center mb-16">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-6">
              Simple <GradientText>Pricing</GradientText>
            </h2>
            <p className="text-xl text-gray-300 mb-8">
              Choose the plan that works best for your needs.
            </p>
            
            <div className="flex items-center justify-center mb-8">
              <span className={`mr-3 ${isAnnual ? 'text-white' : 'text-gray-400'}`}>Monthly</span>
              <button
                onClick={() => setIsAnnual(!isAnnual)}
                className="relative inline-flex h-6 w-12 items-center rounded-full bg-gray-700"
              >
                <span className="sr-only">Toggle billing frequency</span>
                <span
                  className={`inline-block h-4 w-4 transform rounded-full bg-white transition ${
                    isAnnual ? 'translate-x-7' : 'translate-x-1'
                  }`}
                />
              </button>
              <span className={`ml-3 flex items-center ${isAnnual ? 'text-white' : 'text-gray-400'}`}>
                Annual
                <span className="ml-2 rounded-full bg-green-900 px-2 py-0.5 text-xs text-green-100">
                  Save 20%
                </span>
              </span>
            </div>
          </motion.div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {plans.map((plan, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: index * 0.2 }}
              viewport={{ once: true }}
              className={`relative rounded-xl overflow-hidden ${
                plan.popular ? 'md:-mt-4 md:mb-4' : ''
              }`}
            >
              {plan.popular && (
                <div className="absolute top-0 right-0 bg-gradient-to-r from-yellow-400 to-orange-500 text-gray-900 font-bold py-1 px-4 text-sm">
                  Most Popular
                </div>
              )}
              
              <div className="bg-gray-900/70 backdrop-blur-sm p-6 h-full flex flex-col relative overflow-hidden">
                <LightCone
                  color={plan.color}
                  intensity={0.15}
                  effect="breathing"
                  className="absolute inset-0"
                >
                  <div></div>
                </LightCone>
                
                <div className="relative z-10 flex-1">
                  <h3 className="text-2xl font-bold mb-2">{plan.name}</h3>
                  <p className="text-gray-300 mb-6">{plan.description}</p>
                  
                  <div className="mb-6">
                    <span className="text-4xl font-bold">${plan.price}</span>
                    <span className="text-gray-300 ml-2">/month</span>
                    {isAnnual && <p className="text-sm text-gray-400">Billed annually</p>}
                  </div>
                  
                  <ul className="space-y-3 mb-8">
                    {plan.features.map((feature, i) => (
                      <li key={i} className="flex items-start">
                        <svg className="h-6 w-6 text-green-400 mr-2 flex-shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                        </svg>
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                  
                  <div className="mt-auto">
                    <Button
                      variant={plan.popular ? "primary" : "outline"}
                      className="w-full"
                      href="#beta"
                    >
                      {plan.price === 0 ? "Get Started" : "Join Beta"}
                    </Button>
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
