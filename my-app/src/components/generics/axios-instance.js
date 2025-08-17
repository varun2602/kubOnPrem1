import axios from "axios";

export const api = axios.create({
  baseURL: "http://localhost:8000", // your API base URL
  timeout: 10000, // optional
  headers: {
    "Content-Type": "application/json"
  }
});


