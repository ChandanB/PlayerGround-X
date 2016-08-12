//
//  ignApi.h
//  PlayerGround X
//
//  Created by Chandan Brown on 8/12/16.
//  Copyright © 2016 Gaming Recess. All rights reserved.
//

#ifndef ignApi_h
#define ignApi_h


#endif /* ignApi_h */

$url = "https://videogamesrating.p.mashape.com/get.php?count=5&game=World+of+Warcraft";

$headers = array(
                 'X-Mashape-Key' => 'iQCpZr4YWLmsh8ZcjNiXFIJlhYc9p1gsXLFjsnx6zkgaLyLskF'
                 );

HttpResponse response = Unirest.get($url, $headers).asJson();

