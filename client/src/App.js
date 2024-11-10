import "./App.css";

import Nav from "react-bootstrap/Nav";
import Navbar from "react-bootstrap/Navbar";
import NavDropdown from "react-bootstrap/NavDropdown";
import AssignRoles from "./AssignRoles";
import Home from "./Home";
import AddMed from "./AddMed";
import Supply from "./Supply";
import Track from "./Track";
import Container from "react-bootstrap/Container";

import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import { AppNavbar } from "./AppNavbar";

function App() {

  const appStyle = {
   
    backgroundSize: 'cover',
    backgroundRepeat: 'no-repeat',
    backgroundAttachment: 'fixed',
    backgroundPosition: 'center',
    minHeight: '100vh'
    
  };
  return (
    <div  className="App" style={appStyle}>
      {/* <AppNavbar></AppNavbar> */}

      <Router>
        <Switch>
          <Route path="/" exact component={Home} />
          <Route path="/roles" component={AssignRoles} />
          <Route path="/addmed" component={AddMed} />
          <Route path="/supply" component={Supply} />
          <Route path="/track" component={Track} />
        </Switch>
      </Router>
      
    </div>
  );
}

export default App;
