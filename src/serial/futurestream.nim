import asyncdispatch
import ./serialport
from ./serialstream import BufferSize

proc readToStream*(p: ASyncSerialPort, s: FutureStream[string]) {.async.} =
  ## Reads data from the serial port and writes it to the future stream
  while p.isOpen:
    let data = await p.read(int32(BufferSize))
    await s.write(data)

proc writeFromStream*(p: AsyncSerialPort, s: FutureStream[string]) {.async.} =
  ## Writes data from the future stream to the serial port
  while true:
    let (hasData, data) = await s.read()
    if hasData:
      await p.writeAll(data)
    else:
      break
