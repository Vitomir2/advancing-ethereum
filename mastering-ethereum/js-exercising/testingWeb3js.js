(async () => {
  try {
    const mainWallet = "0x0e06D2876F1451B07aeb4D6B3b5e32C10884C197";
    const secondaryWallet = "0x703E5c7c635Ee3FFf15936B0B4C01E95BFD001B0";
    let blockNumber = await web3.eth.getBlockNumber()
    console.log('current block number : ', blockNumber)
    console.log('get tx count: ', await web3.eth.getTransactionCount(mainWallet));
    
    const messageHex = web3.utils.toHex("This is a message for the recipient");
    // await web3.eth.sendTransaction({ from: mainWallet, to: secondaryWallet, value: 0, data: "" });
    // await web3.eth.sendTransaction({ from: mainWallet, to: secondaryWallet, value: web3.utils.toWei("0.0001", "ether"), data: "" });
    // await web3.eth.sendTransaction({ from: mainWallet, to: secondaryWallet, value: 0, data: "0x1234" });
    await web3.eth.sendTransaction({ from: mainWallet, to: secondaryWallet, value: web3.utils.toWei("0.0001", "ether"), data: messageHex });
  } catch (e) {
    console.log(e.message)
  }
})()
