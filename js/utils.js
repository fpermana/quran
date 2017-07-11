
function convertNumber(v) {
    var arabicNumbers = ['۰', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var chars = v.toString().split('');
    for (var i = 0; i < chars.length; i++) {
        if (/\d/.test(chars[i])) {
            chars[i] = arabicNumbers[chars[i]];
        }
    }
    return chars.join('');
}
