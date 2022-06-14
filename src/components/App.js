import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import ManifestNFT from "../abis/ManifestNFT.json";

class App extends Component {
  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockChainData();
  }

  //detect ethetreum provider
  async loadWeb3() {
    const provider = await detectEthereumProvider();

    //modern browsers
    if (provider) {
      //set web3 to provider
      console.log("Ethereum wallet connected");
      window.web3 = new Web3(provider);
    } else {
      //no ethereum provider
      console.log("no ethereum wallet detected");
    }
  }

  async loadBlockChainData() {
    const web3 = window.web3;
    const accounts = await web3.eth.getAccounts();
    this.setState({ account: accounts });

    const networkId = await web3.eth.net.getId();
    console.log(`networkId: ${networkId}`);
    const networkData = ManifestNFT.networks[networkId];
    if (networkData) {
      const abi = ManifestNFT.abi;
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address);
      this.setState({ contract });
      console.log(this.state.contract);
    } else {
      window.alert("smart contract not deployed");
    }
  }

  constructor(props) {
    super(props);
    this.state = {
      account: "",
      contract: null,
    };
  }

  render() {
    return (
      <div>
        <nav className="navbar navbar-dark fixed-top bg-dark flex-mdnowrap p-0 shadow">
          <div
            className="navbar-brand col-sm-3 col-md-3 mr-0"
            style={{ color: "white" }}
          >
            ManifestNFT (NFT)
          </div>
          <ul className="navbar-nav px-3">
            <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
              <small className="text-white">{this.state.account}</small>
            </li>
          </ul>
        </nav>
      </div>
    );
  }
}

export default App;
