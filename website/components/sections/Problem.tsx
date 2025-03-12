import { motion } from 'framer-motion';
import LightCone from '../ui/LightCone';
import GradientText from '../ui/GradientText';

export default function Problem() {
  return (
    <section id="problem" className="py-20">
      <div className="container mx-auto px-4">
        <div className="max-w-3xl mx-auto text-center mb-16">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-6">
              The <GradientText>Problem</GradientText> With Traditional Learning
            </h2>
            <p className="text-xl text-gray-300">
              Students today face unique challenges that traditional education struggles to address.
            </p>
          </motion.div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {[
            {
              title: "Passive Learning",
              description: "Traditional education often relies on passive consumption of information rather than active engagement.",
              icon: "🎓",
            },
            {
              title: "Lack of Personalization",
              description: "One-size-fits-all approaches ignore individual learning styles and needs.",
              icon: "👤",
            },
            {
              title: "Immediate Answers",
              description: "Online resources provide answers but not understanding, hindering deep learning.",
              icon: "⏱️",
            },
          ].map((item, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: index * 0.2 }}
              viewport={{ once: true }}
              className="bg-gray-900/50 backdrop-blur-sm rounded-xl p-6 relative overflow-hidden"
            >
              <LightCone
                color="#9C27B0"
                intensity={0.1}
                effect="breathing"
                className="absolute inset-0"
              >
                <div></div>
              </LightCone>
              <div className="relative z-10">
                <div className="text-4xl mb-4">{item.icon}</div>
                <h3 className="text-xl font-semibold mb-3">{item.title}</h3>
                <p className="text-gray-300">{item.description}</p>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
