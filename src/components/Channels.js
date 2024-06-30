const Channels = ({ provider, account, dappcord, channels, currentChannel, setCurrentChannel }) => {

  const channelHandler = async (channel) => {
    console.log("joining channel", channel)
    const hasJoined = await dappcord.hasJoined(channel.id, account)

    if (hasJoined) {
      console.log("already joined channel")
      setCurrentChannel(channel);
    } else {
      const signer = await provider.getSigner()

      const txn = await dappcord.connect(signer).mint(channel.id, { value: channel.cost })
      await txn.wait()
      setCurrentChannel(channel);
    }

  }

  return (
    <div className="channels">
      <div className="channels__text">
        <h2>Text Channels</h2>

        <ul>
          { channels && channels.map( (channel, index) => (
            <li
              onClick={() => channelHandler(channel)} key={index}
              className={currentChannel && currentChannel.id.toString() === channel.id.toString() ? "active" : ""}>
              {channel.name}
            </li>
          ))}
        </ul>

      </div>

      <div className="channels__voice">
        <h2>Voice Channels</h2>

        <ul>
          <li>Channel 1</li>
          <li>Channel 2</li>
          <li>Channel 3</li>
        </ul>
      </div>
    </div>
  );
}

export default Channels;