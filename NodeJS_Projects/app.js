const {readFileSync,read}=require('fs');

console.log('start');
const content = readFileSync('./file.txt','utf8');
console.log(content);
// readFile('./file.txt','utf8',function(error,content){
//     if (error) {
//         console.error('Error occured',error);
//         process.exit();
//     }
// console.log(content);
// });

console.log('end');