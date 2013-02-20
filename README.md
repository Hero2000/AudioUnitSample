AudioUnitSample
===============

Example usage of RemoteIO and multichannel mixer Audio Units

**Demo 1** is an example of using RemoteIO for playthrough. The output scope of the input element of the RemoteIO unit is connected to the zeroth element of the multichannel mixer unit, whose output is connected to the input scope of the output element of the RemoteIO unit. 

**Demo 2** is an example of mixing two audio streams. The two samples are from "Float On" by Modest Mouse and "What You Know" by Two Door Cinema Club. The streams are synchronized, and their volume can be controlled independently. There is a known bug which causes noise to be generated when reading past the end of the files, but the demo can be reset by pressing the "Demo 2" button again. It would be an interesting exercise to seek back to offset 0 whenever it is determined that an EOF condition has occurred, but this would cause the streams to get out of sync, since they are not the exact same length.
