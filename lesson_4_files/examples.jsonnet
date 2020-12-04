// ##############################
// ##############################
{
    number: 123,
    text_1: |||
        The Tom Collins is essentially gin and
        lemonade.  The bitters add complexity.
    |||,
    text_2: 'A clear \n red drink.',
    text_3: @'A clear \n red drink.',
    'test test': 345
}


// ##############################
// ##############################
// Variables

// A regular definition.
// local house_rum = 'Banks Rum';       // <==

// {
//   // A definition next to fields.
//   local pour = 1.5,                  // <==
//   local lime_qty = 2,                // <==

//   Daiquiri: {
//     ingredients: [
//       { kind: house_rum, qty: pour },
//       { kind: 'Lime', qty: lime_qty },
//       { kind: 'Simple Syrup', qty: 0.5 },
//     ],
//   },
// }


// ##############################
// ##############################
// References

// {
//   n1_text: 'some text',
//   // self refers to the current object.
//   n2_text: self.n1_text,

//   n3_object: {
//     // $ refers to the outer-most object.
//     n31_text: $.n2_text,
//     n32_text: $['n4 text'],
//     n2_text: 'n3_object_n2_text',
//   },

//   'n4 text': 'another text',

//   n5_text: $.n6_object.n61_object.n611_text,
//   n6_object: {
//     n61_object: {
//       n611_text: 'n611 text',
//     },
//   },

//   n7_array: [
//     { text: 'element 0' },
//     { text: 'element 1' },
//     { text: 'element 2' },
//     { text: 'element 3' },
//     { text: 'element 4' },
//   ],

//   // [10] looks up an array element.
//   n8_text: self.n7_array[1],

//   // Array slices like arr[10:20:2] are allowed, like in Python.
//   n9_array: self.n7_array[1:3],
// }


// ##############################
// ##############################
// In order to refer to objects between the current and outer-most object, we use a variable to create a name for that level:

// {
//   Martini: {
//     local drink = self,   // <==
//     ingredients: [
//       { kind: "Farmer's Gin", qty: 1 },
//       {
//         kind: 'Dry White Vermouth',
//         qty: drink.ingredients[0].qty,
//       },
//     ],
//     garnish: 'Olive',
//     served: 'Straight Up',
//   },
// }


// ##############################
// ##############################
// Arithmetic

// {
//   concat_array: [1, 2, 3] + [4],
//   concat_string: '123' + 4,
//   equality1: 1 == '1',
//   equality2: [{}, { x: 3 - 1 }]
//              == [{}, { x: 2 }],
//   ex1: 1 + 2 * 3 / (4 + 5),
//   // Bitwise operations first cast to int.
//   ex2: self.ex1 | 3,
//   // Modulo operator.
//   ex3: self.ex1 % 2,
//   // Boolean logic
//   ex4: (4 > 3) && (1 <= 3) || false,
//   // Mixing objects together
//   obj: { a: 1, b: 2 } + { b: 3, c: 4 },
//   // Test if a field is in an object
//   obj_member: 'foo' in { foo: 1 },
//   // String formatting
//   str1: 'The value of self.ex2 is '
//         + self.ex2 + '.',
//   str2: 'The value of self.ex2 is %g.'
//         % self.ex2,
//   str3: 'ex1=%0.2f, ex2=%0.2f'
//         % [self.ex1, self.ex2],
//   // By passing self, we allow ex1 and ex2 to
//   // be extracted internally.
//   str4: 'ex1=%(ex1)0.2f, ex2=%(ex2)0.2f'
//         % self,
//   // Do textual templating of entire files:
//   str5: |||
//     ex1=%(ex1)0.2f
//     ex2=%(ex2)0.2f
//   ||| % self,
// }


// ##############################
// ##############################
// Functions

// // Default arguments are like Python:
// local my_function(x, y=10) = x + y;

// // Method inside object (with closure):
// local my_var = 1000;
// local my_object = {
//   my_method(x): x * my_var,
// };

// // Define a local multiline function.
// local multiline_function(x) =
//   // One can nest locals.
//   local temp = x * my_function(1, 2);
//   {
//     num: temp,
//     text: 'some text',
//   };

// // result object:
// {
//   n1_my_function_result: my_function(2),
//   n2_multiline_function_result: multiline_function(4),
//   n3_my_object_result: my_object.my_method(2),
//   n4_inline_function_result: (function(x) x * x)(5),

//   // https://jsonnet.org/ref/stdlib.html
//   n5_stdlib_result: std.length('hello'),
// }


// ##############################
// ##############################
// Conditionals

// local some_fun(some_param) ={
//     local l1 = if some_param then 1 else 2,

//     n1_number: l1,
//     n2_text: if(some_param) then 'text',
//     [if some_param then 'n3_text']: 'text 2',
// };

// {
//     n1_result_false: some_fun(false),
//     n2_result_true: some_fun(true)
// }


