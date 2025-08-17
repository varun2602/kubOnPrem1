import { useState } from 'react'
import './App.css'
import MyForm from './components/myForm/myForm'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <MyForm/>
    </>
  )
}

export default App
