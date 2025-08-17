import React from 'react';
import { useState } from 'react';
import "./myForm.css"
import * as formhandlers from "./formLogic.js"

export default function MyForm() {
  const {name, setName, email, setEmail, position, setPosition, password, setPassword} = formhandlers.useFormFields()
  return (
    <div>
      <div className="form-body">
        <div className="row">
          <div className="form-holder">
            <div className="form-content">
              <div className="form-items">
                <h3>Register Today</h3>
                <p>Fill in the data below.</p>
                <form className="requires-validation" noValidate>
                  <div className="col-md-12">
                    <input className="form-control" type="text" name="name" value = {name} onChange={(event) => formhandlers.handleNameEntry(event, setName)} placeholder="Full Name" required />
                    <div className="valid-feedback">Username field is valid!</div>
                    <div className="invalid-feedback">Username field cannot be blank!</div>
                  </div>

                  <div className="col-md-12">
                    <input className="form-control" type="email" name="email" value= {email} onChange={(event) => formhandlers.handleEmail(event, setEmail)} placeholder="E-mail Address" required />
                    <div className="valid-feedback">Email field is valid!</div>
                    <div className="invalid-feedback">Email field cannot be blank!</div>
                  </div>

                  <div className="col-md-12">
                    <select className="form-select mt-3" required name="position" value= {position} onChange={(event) => formhandlers.handlePosition(event, setPosition)}>
                      <option disabled value="">Position</option>
                      <option value="jwebdev">Junior Web Developer</option>
                      <option value="swebdev">Senior Web Developer</option>
                      <option value="pmanager">Project Manager</option>
                    </select>
                    <div className="valid-feedback">You selected a position!</div>
                    <div className="invalid-feedback">Please select a position!</div>
                  </div>

                  <div className="col-md-12">
                    <input className="form-control" type="password" name="password" value={password}  onChange={(event) => formhandlers.handlePassword(event, setPassword)} placeholder="Password" required />
                    <div className="valid-feedback">Password field is valid!</div>
                    <div className="invalid-feedback">Password field cannot be blank!</div>
                  </div>

                  <div className="col-md-12 mt-3">
                    <label className="mb-3 mr-1" htmlFor="gender">Gender: </label>

                    <input type="radio" className="btn-check" name="gender" id="male" autoComplete="off" required />
                    <label className="btn btn-sm btn-outline-secondary" htmlFor="male">Male</label>

                    <input type="radio" className="btn-check" name="gender" id="female" autoComplete="off" required />
                    <label className="btn btn-sm btn-outline-secondary" htmlFor="female">Female</label>

                    <input type="radio" className="btn-check" name="gender" id="secret" autoComplete="off" required />
                    <label className="btn btn-sm btn-outline-secondary" htmlFor="secret">Secret</label>

                    <div className="valid-feedback mv-up">You selected a gender!</div>
                    <div className="invalid-feedback mv-up">Please select a gender!</div>
                  </div>

                  <div className="form-check">
                    <input className="form-check-input" type="checkbox" value="" id="invalidCheck" required />
                    <label className="form-check-label" htmlFor="invalidCheck">
                      I confirm that all data are correct
                    </label>
                    <div className="invalid-feedback">Please confirm that the entered data are all correct!</div>
                  </div>

                  <div className="form-button mt-3">
                    <button id="submit-button" type="button" className="btn btn-primary" onClick={(e) => formhandlers.handleFormSubmit(e, {name, email, position, password})}>Submit</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

