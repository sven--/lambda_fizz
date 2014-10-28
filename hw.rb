# -*- coding: utf-8 -*-
#http://otfried-cheong.appspot.com/courses/cs422/hw2.html
require "./fizzbuzz"
require "./interface"
require "Prime"


puts "------------------------------------------------"
puts "PROBLEM 1"
puts ""

PHI1 = ->(p) { PAIR.(RIGHT.(p)).(INC.(RIGHT.(p)))}
HW1 = ->(n) { LEFT.(n.(PHI1).(PAIR.(ZERO).(ZERO))) }

(0..6).each do |i|
  val = ZERO
  i.times{val = INC.call(val)}
  puts "#{to_integer(val)}\t#{to_integer(HW1.(val))}"
end

puts "------------------------------------------------"
puts "PROBLEM 2"
puts ""

PHI2 = ->(p) { PAIR.(MUL.(LEFT.(p)).(RIGHT.(p))).(INC.(RIGHT.(p)))}
HW2 = ->(n) { LEFT.(n.(PHI2).(PAIR.(ONE).(ONE))) }

(0..6).each do |i|
  val = ZERO
  i.times{val = INC.call(val)}
  puts "#{to_integer(val)}\t#{to_integer(HW2.(val))}"
end

puts "------------------------------------------------"
puts "PROBLEM 3"
puts ""

#pair keeps (h_past, y)
PHI3 = ->(g) {->(x) { ->(p) {
      PAIR.(g.(x).(RIGHT.(p)).(LEFT.(p))).(INC.(RIGHT.(p))) } } }
HW3 = ->(f) { ->(g) { ->(x) { ->(y) {
        LEFT.(y.(PHI3.(g).(x)).(PAIR.(f.(x)).(ZERO))) } } } }

#h(x,y) = y-1 (x dosen't matter)
HW1_F = ->(x) {
  ZERO }
HW1_G = ->(x) { ->(y) { ->(h_past) {
      y
  } } }

#h(x,y) = y! (x dosen't matter)
HW2_F = ->(x) {
  ONE }
HW2_G = ->(x) { ->(y) { ->(h_past) {
      MUL.(h_past).(INC.(y))
  } } }

#h(x,y) = x+y
ADD_F = ->(x) {
  x }
ADD_G = ->(x) { ->(y) { ->(h_past) {
      INC.(h_past)
  } } }

(0..6).each do |i|  
  val = ZERO
  i.times{val = INC.call(val)}
  puts "#{to_integer(val)}\t#{to_integer(HW3.(HW1_F).(HW1_G).(HUNDRED).(val))}\t#{to_integer(HW3.(HW2_F).(HW2_G).(HUNDRED).(val))}\t#{to_integer(HW3.(ADD_F).(ADD_G).(val).(val))}"
end

puts "------------------------------------------------"
puts "PROBLEM 4"
puts ""

puts "
(T1T2)R
= (#y.((T2y)T2))R
= (T2R)T2
= (#x.R((xR)x))T2
= R((T2R)T2)

R((T1T2)R)
= R((#y.((T2y)T2))R)
= R((T2R)T2)"


puts "------------------------------------------------"
puts "PROBLEM 5"
puts ""

puts "
We can simulate Turing machine by 2 stacks.
state = old_state X {Initial, Ongoing},
final state is no more final state (old_final_state)
add new final state.
symbol = old_symbol + Mark

Use mark to specify head.
input[Tape -> stack A] : insert mark before head position
(Initial state) Pop stack A and push it to B until we meet mark.
Meet mark -> Pop mark, change state's second parameter to Ongoing.
Entered old_final_state -> Pop stack A and push it to B until the end. If A is empty and old_final_state -> transition to final_state, halt.
output[stack B -> Tape] 
"

puts "------------------------------------------------"
puts "PROBLEM 6"
puts ""

$x = 0
$y = 0
$z = 0
$halt = nil

def move_to_y() #until x extincts
  return $halt if !$halt.nil?  
  $x -= 1
  $x.zero??
    ($halt = "NO") :
    ($x -= 1; $y += 1)
  move_to_y() if(!$x.zero?)
end

def move_to_x() #until y extincts
  return $halt if !$halt.nil?
  $y -= 1
  $y.zero??
    ($halt = "NO") :
    ($y -= 1; $x += 1)
  move_to_x() if(!$y.zero?)
end


def _prob6()
  return $halt if !$halt.nil?  
  if($y.zero?) #x,0,z
    if($x.zero?)
      $halt = "YES"
    else
      $x -= 1
      $x.zero??
        ($halt = "YES") :
        ($x += 1; move_to_y(); $z += 1)
    end
  else #0,y,z
    $y -= 1
    $y.zero??
      ($halt = "YES") :
      ($y += 1; move_to_x(); $z += 1)
  end
  _prob6()
end

def prob6(n)
  $x = n
  $y = 0
  $z = 0
  $halt = nil
  _prob6()
end

(0..1024).each{|i| prob6(i); if($halt == "YES") then puts "#{i}\t#{$z}" end}


puts "------------------------------------------------"
puts "PROBLEM 7"
puts ""

sample_table = [
         Rational(17,91),
         Rational(78,85),
         Rational(19,51),
         Rational(23,38),
         Rational(29,33),
         Rational(77,29),
         Rational(95,23),
         Rational(77,19),
         Rational(1,17),
         Rational(11,13),                  
         Rational(13,11),
         Rational(15,14),
         Rational(15,2),
         Rational(55,1)
        ]

def FRACTRAN(table, n)
  sleep(0.1)
  pd = Prime.prime_division(n)
  x = table.detect{|x| (n%x.denominator).zero?}
  x.nil??
    n :
#    FRACTRAN(table, x*n)
    if(x.numerator%P[10] == 0) then return "INFLOOP"
    else FRACTRAN(table, x*n) end
end

#FRACTRAN(sample_table, 2)


P = Prime.first(25)
my_table = [
            #INF LOOP
            Rational(P[10],P[11]),
            Rational(P[11],P[10]),

            #1->0, signal needed
            Rational(P[0]*P[23],P[1]*P[1]*P[22]),
            Rational(P[0]*P[22],P[1]*P[1]*P[23]),
            Rational(P[10],P[0]*P[1]*P[22]),
            Rational(P[10],P[0]*P[1]*P[23]),
            
            #0->1, signal off
            Rational(P[1],P[0]*P[0]*P[22]),
            Rational(P[1],P[0]*P[0]*P[23]),
            
            #0->1
            Rational(P[1],P[0]*P[0]),
            Rational(P[10],P[0]*P[1]),

            #1->0, signal on
            Rational(P[0]*P[22],P[1]*P[1]),
            Rational(P[10],P[0]*P[1]),

            #if only one remains, HALT
            Rational(1,P[0]),
            Rational(1,P[1]),
        ]


(64..128).each{|i| puts "#{i}\t#{FRACTRAN(my_table, Rational(2**i,1))}"}

# require 'Timeout'
# (1..64).each{|i|
#   begin
#     Timeout::timeout(5) {puts "#{i}\t#{FRACTRAN(my_table, Rational(2**i,1))}"}
#   rescue Timeout::Error
#     puts "#{i}\tTAKES INFINITE LOOP"
#   end
# }
