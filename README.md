# VLMHarlemShake

*(see the blog post about this [here](http://velosmobile.com/2013/03/08/harlem-shake-for-ios/))*

VLMHarlemShake is a simple class to make your iPhone or iPad app go crazy. You probably thought the [Harlem Shake](http://www.youtube.com/watch?v=384IUU43bfQ/) was over, didn't you? It probably is, but here's one more stupid harlem shake inspired gag.

**NOTE: Please don't ship this. And if you do, do so at your own peril. I personally wouldn't though as it does some pretty nasty subview diving.**

## Usage

First include AVFoundation.framework and QuartzCore.framework into your project. Then just instantiate a VLMHarlemShake object 

``` objective-c

// create the shake object and point it to the view you want to 'shake' at first.
VLMHarlemShake *harlemShake = [[VLMHarlemShake alloc] initWithLonerView:lonerView];

// start shaking!
[harlemShake shakeWithCompletion:^{
    // called when the shaking is over.
}];

```

## Demo

I've included the example project HarlemShakeDemo. It's pretty simple. You can also check out a [video of it in action](http://velosmobile.com/2013/03/08/harlem-shake-for-ios/)

## Contact

If you have any thoughts or comments, send us an email at feedback at the domain velosmobile.com.

## Why?

I don't really have a good answer for that.

## Acknowledgements

This idea loosely based on [YouTube's harlem shake thing](http://www.youtube.com/results?search_query=do+the+harlem+shake). Audio is [Harlem Shake by Baauer](https://soundcloud.com/baauer/harlem-shake). Please observe copyright and stuff.