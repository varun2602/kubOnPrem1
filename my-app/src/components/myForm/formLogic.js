import { useState } from "react"
import * as apiHandlers from "../generics/axios-instance.js"
import axios from "axios"

function handlePosition(event, setPosition){
    // console.log("position 1", position)
    setPosition(event.target.value) 
    // console.log("position debug:", position)
  }
function handleNameEntry(event, setName){
    setName(event.target.value)
}
function handleEmail(event, setEmail){
    setEmail(event.target.value)
}

function handlePassword(event, setPassword){
    setPassword(event.target.value)
}


function useFormFields(){
    const [name, setName] = useState("")
    const [email, setEmail] = useState("")
    const [position, setPosition] = useState("")
    const [password, setPassword] = useState("")
    return {name, setName, email, setEmail, position, setPosition, password, setPassword}
}


async function handleFormSubmit(event, formData){
    let form_data = new FormData()
    const {name, email, position, password} = formData
    form_data["name"] = name
    form_data["email"] = email 
    form_data["position"] = position 
    form_data["password"] = password 
    const response = await apiHandlers.api.post("/api/create-student-entry", formData).catch(error => console.log(`An error occurred:${error}`))
    // if (response.status === 200){
    //     window.location.reload()
    // }
    console.log("api_response", response)

}

export {useFormFields, handleEmail, handleFormSubmit, handleNameEntry, handlePosition, handlePassword}