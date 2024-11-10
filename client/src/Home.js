import React from "react";
import { useHistory } from "react-router-dom";
import Nav from "react-bootstrap/Nav";
import Navbar from "react-bootstrap/Navbar";
import NavDropdown from "react-bootstrap/NavDropdown";

function Home() {
  const history = useHistory();
  const redirect_to_roles = () => {
    history.push("/roles");
  };
  const redirect_to_addmed = () => {
    history.push("/addmed");
  };
  const redirect_to_supply = () => {
    history.push("/supply");
  };
  const redirect_to_track = () => {
    history.push("/track");
  };
  const inline = {
   
    backgroundSize: "cover",
    backgroundPosition: "center",
    backgroundImage: `url(${process.env.PUBLIC_URL + '/image.png'})`,
   
    fontSize: "16px",
    marginTop: "2px",
    color: "black", // Added for better text visibility
    // textShadow: "1px 1px 2px white", // Added for better text readability

    padding:'150px',
    
    
    
  };

  return (
    <div>
      <div >
        <Navbar style={{paddingLeft:'400px'}} bg="success" data-bs-theme="dark">
          <container>
            {/* <Navbar.Brand href="/home">Navbar</Navbar.Brand> */}
            <Nav className="me-auto" style={{background:'white', borderRadius:'12px'}}> 
              <Nav.Link  style={{color:'black'}} onClick={redirect_to_roles}>Register</Nav.Link>
              <Nav.Link style={{color:'black'}} onClick={redirect_to_addmed}>Order Medicines</Nav.Link>
              <Nav.Link style={{color:'black'}} onClick={redirect_to_supply}>
                Control Supply Chain
              </Nav.Link>
              <Nav.Link style={{color:'black'}} onClick={redirect_to_track}>Track Medicine</Nav.Link>
            </Nav>
          </container>
        </Navbar>

        <div style={inline}>
          <br />
          <h6>Follow Instructions :</h6>
          <h6>
            (Note: Here <u>Owner</u> is the person who deployed the smart
            contract on the blockchain)
          </h6>
          <h5>
            Step 1: Owner Should Register Raw material suppliers ,Manufacturers,
            Distributors and Retailers
          </h5>
          <h6>
            (Note: This is a one time step. Skip to step 2 if already done)
          </h6>

          <h5>Step 2: Owner should order medicines</h5>

          <br />
          <h5>Step 3: Control Supply Chain</h5>
          <h5>Step 4: Track Medicines</h5>

          <br />
          <hr />
          <br />
        </div>
      </div>
    </div>
  );
}

export default Home;
