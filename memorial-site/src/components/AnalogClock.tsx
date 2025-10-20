import { useEffect, useState } from 'react'

export default function AnalogClock() {
  const [time, setTime] = useState(new Date())

  useEffect(() => {
    const timer = setInterval(() => {
      setTime(new Date())
    }, 1000)

    return () => clearInterval(timer)
  }, [])

  const seconds = time.getSeconds()
  const minutes = time.getMinutes()
  const hours = time.getHours() % 12

  const secondAngle = (seconds * 6) - 90 // 6 degrees per second
  const minuteAngle = (minutes * 6 + seconds * 0.1) - 90 // 6 degrees per minute
  const hourAngle = (hours * 30 + minutes * 0.5) - 90 // 30 degrees per hour

  return (
    <div className="flex flex-col items-center mb-0">
      {/* Tambor Arch Frame */}
      <div
        style={{
          width: '100px',
          height: '70px',
          backgroundColor: '#1A1F2E',
          borderRadius: '50px 50px 0 0',
          padding: '8px 8px 0 8px',
          boxShadow: `
            0 4px 8px rgba(0, 0, 0, 0.4),
            inset 0 2px 4px rgba(255, 255, 255, 0.1),
            inset 0 -2px 4px rgba(0, 0, 0, 0.3)
          `,
          border: '1px solid rgba(255, 255, 255, 0.1)',
          borderBottom: 'none',
          marginBottom: '-1px'
        }}
      >
        {/* Clock Face */}
        <div
          style={{
            width: '84px',
            height: '54px',
            backgroundColor: '#F5F5DC',
            borderRadius: '42px 42px 0 0',
            position: 'relative',
            boxShadow: 'inset 0 2px 4px rgba(0, 0, 0, 0.2)'
          }}
        >
          {/* Clock center point */}
          <div
            style={{
              position: 'absolute',
              width: '100%',
              height: '100%',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center'
            }}
          >
            {/* Hour hand */}
            <div
              style={{
                position: 'absolute',
                width: '2px',
                height: '18px',
                backgroundColor: '#1A1F2E',
                transformOrigin: 'bottom center',
                transform: `rotate(${hourAngle}deg) translateY(-9px)`,
                borderRadius: '2px',
                bottom: '50%'
              }}
            />

            {/* Minute hand */}
            <div
              style={{
                position: 'absolute',
                width: '1.5px',
                height: '24px',
                backgroundColor: '#1A1F2E',
                transformOrigin: 'bottom center',
                transform: `rotate(${minuteAngle}deg) translateY(-12px)`,
                borderRadius: '1.5px',
                bottom: '50%'
              }}
            />

            {/* Second hand */}
            <div
              style={{
                position: 'absolute',
                width: '1px',
                height: '26px',
                backgroundColor: '#6B302F',
                transformOrigin: 'bottom center',
                transform: `rotate(${secondAngle}deg) translateY(-13px)`,
                borderRadius: '1px',
                bottom: '50%'
              }}
            />

            {/* Center dot */}
            <div
              style={{
                width: '5px',
                height: '5px',
                backgroundColor: '#1A1F2E',
                borderRadius: '50%',
                position: 'absolute',
                zIndex: 10
              }}
            />
          </div>
        </div>
      </div>
    </div>
  )
}
