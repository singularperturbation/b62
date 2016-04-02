const doc = """
Base 62 Encoder/Decoder command line utility

Usage:
  b62 (-e | --encode | -d | --decode) [<input_string>]
  b62 (-e | --encode | -d | --decode)
  b62 (-h | --help)
  b62 --version

Options:
  -e --encode  Convert from integer to base62 representation.
  -d --decode  Convert from base62 representation to integer.
  -h --help    Show this screen.
  --version    Show version.
"""

import docopt
from base62 import nil
from strutils import parseInt

let args = docopt(doc, version="B62 1.0")

template handleFromStandardIn(line, actions: untyped) =
  for line in stdin.lines:
    actions


proc main() =
  let
    (encode,decode) = base62.GenerateFunctionPair()

  # TODO: input_string should be a filename instead of string to convert?
  # TODO: If can't convert (-1 from decode) should throw error
  if args["<input_string>"]:

    var inputString: string = $args["<input_string>"]

    try:
      if args["--encode"]:
        echo encode(parseInt(inputString))
      else:
        echo decode(inputString)
    except ValueError, OverflowError:
      let e = getCurrentException()
      echo "Could not encode provided input " & inputString & " as an integer"
      raise e
  else:
    if args["--encode"]:
      handleFromStandardIn(line):
        try:
          echo line.parseInt.encode
        except ValueError, OverflowError:
          let e = getCurrentException()
          echo "Could not encode provided input " & line & " as an integer"
          raise e
    elif args["--decode"]:
      handleFromStandardIn(line):
        echo line.decode

when isMainModule:
  main()
