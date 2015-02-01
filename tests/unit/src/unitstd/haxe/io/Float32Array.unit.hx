
var emulated = haxe.io.ArrayBufferView.EMULATED;

var b = new haxe.io.Float32Array(5);
b[0] == 0;
b[4] == 0;
b.length == 5;

// check float write
b[1] = 1.25;
b[1] == 1.25;

// check loss of precision due to 32 bits
if( !emulated ) {
	b[1] = 8589934591.;
	b[1] == 8589934592.;
}

// set
for( i in 0...5 )
	b[i] = i + 1;
b[0] == 1;
b[4] == 5;

// access outside bounds is unspecified but should not crash
try b[-1] catch( e : Dynamic ) {};
try b[5] catch(e : Dynamic) {};

// same for writing
try b[-1] = 55 catch( e : Dynamic ) {};
try b[5] = 55 catch(e : Dynamic) {};

var b2 = b.sub(1,3);
b2[0] == 2;
b2[2] == 4;
b2.length == 3;

// check memory sharing
if( !emulated ) {
	b2[0] = 0xCC;
	b2[0] == 0xCC;
	b[1] == 0xCC;
}

// should we allow writing past bounds ?
try b2[-1] = 0xBB catch( e : Dynamic ) {};
b[0] == 1;

try b2[3] = 0xBB catch( e : Dynamic ) {};
b[4] == 5;


b.view == b.view; // no alloc

b.view.buffer == b2.view.buffer;
b.view.byteLength == 20;
b.view.byteOffset == 0;
b2.view.byteLength == 12;
b2.view.byteOffset == 4;
