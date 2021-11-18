import javax.management.*;
import javax.management.remote.*;

public class JmxInvoke {

    public static void main(String... args) throws Exception {
        JMXConnectorFactory.connect(new JMXServiceURL(args[0]))
            .getMBeanServerConnection().invoke(new ObjectName(args[1]), args[2], new Object[]{}, new String[]{});    
    }

}
