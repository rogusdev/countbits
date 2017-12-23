
import java.lang.System;
import java.io.DataOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Map;
import java.util.HashMap;

import com.google.gson.Gson;

public class CountBits
{
    // must be less than 126 to be a positive int in a byte!
    //  max bits should be ONE less than the actual size, for shifting negative ints
    private static final int MAXBITS = 31;
    private static final int[] b = new int[MAXBITS];

    //private static final int BOT = -2147483648;
    //private static final int TOP = 2147483647;
    private static final int BOT = -147483648;
    private static final int TOP = 147483647;

    // https://stackoverflow.com/questions/1770010/how-do-i-measure-time-elapsed-in-java
    private static final long START = System.nanoTime();

    // https://stackoverflow.com/questions/4300653/conversion-of-nanoseconds-to-milliseconds-and-nanoseconds-999999-in-java
    private static Long elapsedMs() { return (System.nanoTime() - START) / 1000000; }

    public static void main(String[] args) throws IOException, FileNotFoundException
    {
        Map<String, Long> times = new HashMap<String, Long>();
        times.put("start", elapsedMs());

        for (int i = 0; i < MAXBITS; i++) { b[i] = 1 << i; }

        times.put("array", elapsedMs());

        // https://stackoverflow.com/questions/6981555/how-to-output-binary-data-to-a-file-in-java
        DataOutputStream os = new DataOutputStream(new FileOutputStream("counts.bin"));

        times.put("file", elapsedMs());

        byte c;
        for (int j = BOT; j < TOP; j++)
        {
            if ((j % 10000000) == 0) { times.put(Integer.toString(j), elapsedMs()); }
            c = (byte)(j < 0 ? 1 : 0);
            for (int i = 0; i < MAXBITS; i++)
             { c += (byte)((j & b[i]) >> i); }
            os.writeByte(c);
        }

        // last positive int is for sure MAXBITS on bits
        //  we have to do this out of loop or else int rolls around and becomes infinite loop!
        os.writeByte((byte)MAXBITS);

        os.close();
        times.put("end", elapsedMs());
        times.put("average", (times.get("end") - times.get("file")) / (times.size() - 4));

        System.out.println(new Gson().toJson(times));
    }
}

