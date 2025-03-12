/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx}',
    './components/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        'background-grey': '#212121',
        'dark-grey': '#1a1a1a',
        'primary-yellow': '#FFD100',
        'orange-accent': '#FF9500',
        'violet-accent': '#9C27B0',
      },
      boxShadow: {
        'glow-yellow': '0 0 15px 5px rgba(255, 209, 0, 0.3)',
        'glow-violet': '0 0 15px 5px rgba(156, 39, 176, 0.3)',
      },
    },
  },
  plugins: [],
};
