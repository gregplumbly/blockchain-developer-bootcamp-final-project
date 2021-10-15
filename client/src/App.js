import React, { Component } from "react";
import Token from "./contracts/Token.json";
import getWeb3 from "./getWeb3";

import "./App.css";

class App extends Component {
  state = {
    tokenName: "",
    tokenSymbol: "",
    totalStaked: 0,
    totalStakers: 0,
    userStakedBalance: 0,
    etherValue: null,
    web3: null,
    accounts: null,
    contract: null,
    stakeValue: null,
  };

  componentDidMount = async () => {
    try {
      this.handleChange = this.handleChange.bind(this);
      this.handleSubmit = this.handleSubmit.bind(this);

      // Get network provider and web3 instance.
      console.log(this.state.userStakedBalance);
      const web3 = await getWeb3();
      const ethValue = web3.utils.fromWei(
        web3.utils.toBN("1000000000000000000"),
        "ether"
      );
      console.log("***");
      console.log(ethValue);
      // this.setState({ etherValue: ethValue });

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = Token.networks[networkId];
      const instance = new web3.eth.Contract(
        Token.abi,
        deployedNetwork && deployedNetwork.address
      );

      // this.setState({ web3, accounts, contract: instance });

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { accounts, contract } = this.state;

    const tokenName = await contract.methods.name().call();
    this.setState({ tokenName: tokenName });

    const symbol = await contract.methods.symbol().call();
    this.setState({ tokenSymbol: symbol });

    // Get the total staked from the contract
    const response = await contract.methods
      .totalStaked()
      .call(function (err, res) {
        if (err) {
          console.log("An error occured", err);
          return;
        }
        console.log("Total staked is: ", res);
      });
    // Update state with the result.
    this.setState({ totalStaked: response });

    // Get the total number of stakers from the contract
    const stakers = await contract.methods
      .numberOfStakers()
      .call(function (err, res) {
        if (err) {
          console.log("An error occured", err);
          return;
        }
        console.log("Total stakers is: ", res);
      });
    // Update state with the result.
    this.setState({ totalStakers: stakers });

    // Get usersStakedBalance
    const usersStakedBalance = await contract.methods
      .userStakedBalance(accounts[0])
      .call(function (err, res) {
        if (err) {
          console.log("An error occured", err);
          return;
        }
        console.log("user  staked balance is: ", res);
      });
    // Update state with the result.
    this.setState({ userStakedBalance: usersStakedBalance });
  };

  handleChange(event) {
    this.setState({ stakeValue: event.target.value });
  }

  async handleSubmit(event) {
    alert("A value was submitted: " + this.state.stakeValue);
    event.preventDefault();
    const { accounts, contract } = this.state;
    await contract.methods.stake().send({
      from: accounts[0],
      value: this.state.stakeValue,
    });
    const response = await contract.totalStaked;
    this.setState({ totalStakes: response });
  }

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>My Little Ponzi</h1>

        <p>Stake $ETH in order to be able to claim NFT and receive $STK</p>

        <p>Token: name {this.state.tokenName}</p>

        <p>Token symbol: {this.state.tokenSymbol}</p>

        <p>Total staked: {this.state.totalStaked}</p>

        <p>Total stakes: {this.state.totalStakers}</p>

        <p>Your wallet balance:</p>

        <p>Your staked balance: {this.state.etherValue}</p>
        <p>Your staked balance(wei): {this.state.userStakedBalance}</p>

        <form onSubmit={this.handleSubmit}>
          <input
            type="text"
            value={this.state.stakeValue}
            onChange={this.handleChange.bind(this)}
          />
          <input type="submit" value="Stake $ETH" />

          <br />
          <input
            type="text"
            value={this.state.userStakedBalance}
            onChange={this.handleChange.bind(this)}
          />
          <input type="submit" value="Withdraw" />

          <br />
          <br />
          <br />
          <br />
          <input type="submit" value="Claim NFT" />
        </form>
      </div>
    );
  }
}

export default App;
