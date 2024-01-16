#+ AUTHOR: 
#+ Za0Warudo, Vinicius Gomes 
#+ 
#+ EMAIL: 
#+ viniciusgomes24@usp.br
#+
#+ DATE: 
#+ 01/16/2024 
#+ 
#+ DESCRIPTION: 
#+ Implementation of a hash function, based in the EP1 from 
#+ Técnicas de programação from IME-USP 

vector = [ 122, 77, 153, 59, 173, 107, 19, 104, 123, 183, 75, 10,114, 236, 106, 83, 117, 16, 189, 211, 51, 231, 143, 118, 248, 148, 218,245, 24, 61, 66, 73, 205, 185, 134, 215, 35, 213, 41, 0, 174, 240, 177,195, 193, 39, 50, 138, 161, 151, 89, 38, 176, 45, 42, 27, 159, 225, 36,64, 133, 168, 22, 247, 52, 216, 142, 100, 207, 234, 125, 229, 175, 79,220, 156, 91, 110, 30, 147, 95, 191, 96, 78, 34, 251, 255, 181, 33, 221,139, 119, 197, 63, 40, 121, 204, 4, 246, 109, 88, 146, 102, 235, 223,214, 92, 224, 242, 170, 243, 154, 101, 239, 190, 15, 249, 203, 162, 164,199, 113, 179, 8, 90, 141, 62, 171, 232, 163, 26, 67, 167, 222, 86, 87,71, 11, 226, 165, 209, 144, 94, 20, 219, 53, 49, 21, 160, 115, 145, 17,187, 244, 13, 29, 25, 57, 217, 194, 74, 200, 23, 182, 238, 128, 103,140, 56, 252, 12, 135, 178, 152, 84, 111, 126, 47, 132, 99, 105, 237,186, 37, 130, 72, 210, 157, 184, 3, 1, 44, 69, 172, 65, 7, 198, 206,212, 166, 98, 192, 28, 5, 155, 136, 241, 208, 131, 124, 80, 116, 127,202, 201, 58, 149, 108, 97, 60, 48, 14, 93, 81, 158, 137, 2, 227, 253,68, 43, 120, 228, 169, 112, 54, 250, 129, 46, 188, 196, 85, 150, 6, 254, 180, 233, 230, 31, 76, 55, 18, 9, 32, 82, 70 ]

def main () : 
    #++ Get the buffer 
    string = input()
    #++ Not necessary but change to ascii visualization and vector notation 
    string = string.encode("utf-8")
    string_vector = list(string)
    #++ Call step1 
    string_vector = step1(string_vector) 
    #++ Call step2 
    string_vector = step2 (string_vector, vector)
    #++ Call step3 
    string_vector = step3 (string_vector, vector) 
    #++ Call step4 
    string_vector = step4 (string_vector) 
    #++ Convert hex to string 
    string_vector = "".join(string_vector) 
    #++ Print the result 
    print (string_vector) 

def step1 (string) :  
    #++ Verify string size:  
	#++	case1: If already divible by 16, then Return.
	#++ case2: Else fill string with (16-remeinder) until new string size
	#++ be multiple of 16 then Return. 
    remainder = len(string)%16
    if ( remainder == 0 ): 
        return string
    else :
        for i in range (16-remainder):
            string.append(16-remainder) 
        return string 
        

def step2 (string, vector):
    #++ Add a new block of 16 bytes to the string. The new block is made by an algorithm and a magic vector
    block = [0]*16 
    value = 0 
    multiple = len(string) // 16 
    for i in range (multiple): 
        for j in range (16): 
            value = vector[ (string[ i*16 + j ] ^ value) ] ^ block[j] 
            block[j] = value
    
    string = string + block

    return string 


def step3 (string, vector): 
    #++ Using an algorithm converts the string vector in a condensed 48 bytes Hash vector 
    hash = [0]*48 
    multiple = len(string) // 16 
    for i in range (multiple): 
        for j in range(16): 
            hash[ 16 + j ] = string[ i*16 + j]
            hash[ 32 + j ] = ( hash[ 16 + j ] ^ hash[ j ] )
        
        temp = 0 
        for j in range (18): 
            for k in range (48): 
                temp = (hash [ k ] ^ vector[ temp ])
                hash[ k ] = temp 
            
            temp = ( temp + j ) % 256 
    return hash 

def step4 (vector): 
    #++ Converts the first 16 itens of a vector in it's hex version 
    hash_hex = [] 
    for i in range (16) : 
        hex0x = (hex(vector[i]))
        hash_hex.append(hex0x[2:])
    return hash_hex 

#++ Call main
main()