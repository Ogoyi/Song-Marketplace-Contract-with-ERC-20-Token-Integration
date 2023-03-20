 // SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
function transfer(address, uint256) external returns (bool);
function approve(address, uint256) external returns (bool);

function transferFrom(
    address,
    address,
    uint256
) external returns (bool);

function totalSupply() external view returns (uint256);

function balanceOf(address) external view returns (uint256);

function allowance(address, address) external view returns (uint256);

event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
);
}

contract SongMarketplace {
uint internal songsLength = 0;
address internal cUsdTokenAddress = 0x686c626E48bfC5DC98a30a9992897766fed4Abd3;
uint256 internal songId = 0;
    event unpublishSongEvent(uint256 songId);
    event createSongEvent(
    string url,
    string name,
    string artist,
    uint price
);


   struct Song{
       address payable owner;
       string url;
       string name;
        string artist;
        uint price;
        uint256 songId;
         uint createdAt;
   }

    mapping (uint =>  Song) internal songs;

    function getSong(uint _index) public view returns (
    address payable,
    string memory,
    string memory,
    string memory,
    uint,
    uint256,
     uint256


     ) {
    return (  
        songs[_index].owner,
         songs[_index].url,
          songs[_index].name,
           songs[_index].artist,
            songs[_index].price,
             songs[_index].songId,
              songs[_index].createdAt

             
    );
   
}

       function addSong (
    string memory _url,
    string memory _name,
    string memory _artist,
    uint _price
     ) public {

          songs [songsLength] =  Song(
        payable(msg.sender),
         _url,
         _name,
         _artist,
         _price,
         songId,
         block.timestamp

          );
            emit createSongEvent(_url, _name, _artist, _price);

            songsLength++;
      songId++;
     }


      function buySong(uint _index) public payable  {
    require(
      IERC20Token(cUsdTokenAddress).transferFrom(
        msg.sender,
        songs[_index].owner,
        songs[_index].price
      ),
      "Transfer failed."
    );

    
     
}
function getSongIdsByArtist(string memory _artist) public view returns (uint[] memory) {
    uint[] memory songIds = new uint[](songsLength);
    uint count = 0;

    for (uint i = 0; i < songsLength; i++) {
        if (keccak256(bytes(songs[i].artist)) == keccak256(bytes(_artist))) {
            songIds[count] = songs[i].songId;
            count++;
        }
    }

    uint[] memory result = new uint[](count);
    for (uint i = 0; i < count; i++) {
        result[i] = songIds[i];
    }

    return result;
}

function deleteSong(uint _index) public {
    require(_index < songsLength, "Invalid song index");
    require(msg.sender == songs[_index].owner, "Only song owner can delete the song");

    // Remove the song from the mapping
    delete songs[_index];

    // Emit an event to indicate that the song has been unpublished
    emit unpublishSongEvent(_index);
}


function getSongsLength() public view returns (uint) {
return (songsLength);
}

}