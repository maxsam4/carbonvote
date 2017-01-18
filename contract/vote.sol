pragma solidity ^0.4.8;

contract Vote {
    event LogVote(address indexed addr);

    function() payable {
        LogVote(msg.sender);

        if (msg.value > 0) {
            if (!msg.sender.send(msg.value))
                throw;
        }
    }
}
