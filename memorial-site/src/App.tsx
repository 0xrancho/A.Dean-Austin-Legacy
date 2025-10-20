import { useState } from 'react'
import MemorialForm from './components/MemorialForm'
import AnalogClock from './components/AnalogClock'

function App() {
  const [showForm, setShowForm] = useState(false)

  return (
    <div className="min-h-screen" style={{ backgroundColor: '#E0D8C5' }}>
      {/* Hero Section */}
      <div className="container mx-auto px-4 py-12 md:py-20">
        <div className="max-w-4xl mx-auto text-center">
          {/* Hero Portrait */}
          <div className="mb-8">
            <div className="w-96 h-[500px] md:w-[500px] md:h-[650px] mx-auto">
              <img
                src="/hero-portrait.jpg"
                alt="Arthur 'Dean' Austin"
                className="w-full h-full"
                style={{
                  objectFit: 'contain',
                  objectPosition: 'center center'
                }}
              />
            </div>
          </div>

          {/* Title */}
          <h1
            className="text-4xl md:text-6xl font-bold mb-4"
            style={{
              color: '#6B302F',
              fontFamily: "'IBM Plex Serif', serif"
            }}
          >
            Arthur Dean Austin
          </h1>

          <p
            className="text-2xl md:text-3xl text-gray-600 mb-8"
            style={{ fontFamily: "'IBM Plex Mono', monospace" }}
          >
            Digital Archive Coming Soon
          </p>

          <p
            className="text-lg md:text-xl text-gray-700 mb-12 max-w-2xl mx-auto leading-relaxed"
            style={{ fontFamily: "'IBM Plex Mono', monospace" }}
          >
            Share your memories and photos to be part of this lasting tribute.
          </p>

          {/* Analog Clock */}
          <AnalogClock />

          {/* Submit Button */}
          <button
            onClick={() => setShowForm(true)}
            className="text-white font-semibold text-lg px-6 py-3 transform transition hover:scale-105 focus:outline-none focus:ring-4"
            style={{
              backgroundColor: '#1A1F2E',
              borderColor: '#1A1F2E',
              fontFamily: "'IBM Plex Mono', monospace",
              borderRadius: '0 0 8px 8px',
              boxShadow: `
                0 4px 8px rgba(0, 0, 0, 0.4),
                0 2px 4px rgba(0, 0, 0, 0.3),
                inset 0 2px 4px rgba(255, 255, 255, 0.15),
                inset 0 -2px 4px rgba(0, 0, 0, 0.4),
                inset 2px 0 4px rgba(0, 0, 0, 0.2),
                inset -2px 0 4px rgba(0, 0, 0, 0.2)
              `,
              border: '1px solid rgba(255, 255, 255, 0.1)'
            }}
            onMouseEnter={(e) => {
              e.currentTarget.style.backgroundColor = '#0F1419'
              e.currentTarget.style.borderRadius = '0 0 8px 8px'
              e.currentTarget.style.boxShadow = `
                0 4px 8px rgba(0, 0, 0, 0.4),
                0 2px 4px rgba(0, 0, 0, 0.3),
                inset 0 2px 4px rgba(255, 255, 255, 0.15),
                inset 0 -2px 4px rgba(0, 0, 0, 0.4),
                inset 2px 0 4px rgba(0, 0, 0, 0.2),
                inset -2px 0 4px rgba(0, 0, 0, 0.2)
              `
            }}
            onMouseLeave={(e) => {
              e.currentTarget.style.backgroundColor = '#1A1F2E'
              e.currentTarget.style.borderRadius = '0 0 8px 8px'
              e.currentTarget.style.boxShadow = `
                0 4px 8px rgba(0, 0, 0, 0.4),
                0 2px 4px rgba(0, 0, 0, 0.3),
                inset 0 2px 4px rgba(255, 255, 255, 0.15),
                inset 0 -2px 4px rgba(0, 0, 0, 0.4),
                inset 2px 0 4px rgba(0, 0, 0, 0.2),
                inset -2px 0 4px rgba(0, 0, 0, 0.2)
              `
            }}
          >
            Submit a Memory
          </button>
        </div>
      </div>

      {/* Footer */}
      <footer className="text-center py-8 text-gray-500 text-sm">
        <p style={{ fontFamily: "'IBM Plex Mono', monospace" }}>
          In loving memory of Arthur Dean Austin
        </p>
      </footer>

      {/* Memorial Form Modal */}
      {showForm && (
        <MemorialForm onClose={() => setShowForm(false)} />
      )}
    </div>
  )
}

export default App
