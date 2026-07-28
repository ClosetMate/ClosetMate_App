
/** @type {import('tailwindcss').Config} */
export default {
  content: [
  './index.html',
  './src/**/*.{js,ts,jsx,tsx}'
],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
        display: ['Anton', 'sans-serif'],
        fashion: ['Satoshi', 'Inter', 'sans-serif'],
      },
      colors: {
        brand: {
          50: '#F8FAFB',
          100: '#E6F0F5',
          200: '#B8D4E3',
          300: '#7EB6D4',
          400: '#9CA3AF',
          500: '#6B7280',
          900: '#1A1A1A',
        }
      },
      boxShadow: {
        'soft': '0 4px 20px rgba(0, 0, 0, 0.03)',
        'float': '0 10px 40px rgba(0, 0, 0, 0.08)',
      }
    },
  },
  plugins: [],
}
