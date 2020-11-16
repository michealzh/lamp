### func
```go
//func function_name([parameter list]) [return_types]  {
//	函数体
//}

//不支持嵌套,重载,默认参数

//无返回值
func f1() {
}

//返回值是 int 类型
func f2() int {
	return 123
}

//a,b 为int类型形参 int 为指定返回值类型
func f3(a, b int) int {
	return a + b
}

//a,b 为 int 类型形参, c,d 为返回值列表
func f4(a, b int) (c, d int) {
	c = a
	d = b
	return c, d
}

//a,b为 int 类型形参, 返回值为 int,error类型
func f5(a, b int) (int, error) {
	return a + b, nil
}

//不定长变参特性：
//1、不可以在不定长变参后边添加其他参数 func b(a ...int, b string)， 这种写法是错误的
//2、不定长参数可以放在其他参数后边 func b(b string, a ...int)


//... 不定长变参
func f6(a ...int) {

}
//匿名函数
//a := func() {
//	fmt.Println("匿名函数调用")
//}
//a()

type Stu struct {
	height int
	weight int
}

func (Stu) sing(song string) {
	fmt.Println("sing " + song)
}
```

### Go SFTP
[ref](https://sftptogo.com/blog/go-sftp/)
[ref2](https://segmentfault.com/a/1190000019251912)

```go
package main

import (
    "fmt"
    "io"
    "os"
    "net"
    "net/url"
    "bufio"
    "strings"
    "path/filepath"

    "golang.org/x/crypto/ssh"
    "golang.org/x/crypto/ssh/agent"

    "github.com/pkg/sftp"
)

func main() {
    // Get SFTP To Go URL from environment
    rawurl := os.Getenv("SFTPTOGO_URL")

    parsedUrl, err := url.Parse(rawurl)
    if err != nil {
        fmt.Fprintf(os.Stderr, "Failed to parse SFTP To Go URL: %s\n", err)
        os.Exit(1)
    }

    // Get user name and pass
    user := parsedUrl.User.Username()
    pass, _ := parsedUrl.User.Password()

    // Parse Host and Port
    host := parsedUrl.Host
    // Default SFTP port
    port := 22

    hostKey := getHostKey(host)

    fmt.Fprintf(os.Stdout, "Connecting to %s ...\n", host)

    var auths []ssh.AuthMethod

    // Try to use $SSH_AUTH_SOCK which contains the path of the unix file socket that the sshd agent uses 
    // for communication with other processes.
    if aconn, err := net.Dial("unix", os.Getenv("SSH_AUTH_SOCK")); err == nil {
        auths = append(auths, ssh.PublicKeysCallback(agent.NewClient(aconn).Signers))
    }

    // Use password authentication if provided
    if pass != "" {
        auths = append(auths, ssh.Password(pass))
    }
    
    // Initialize client configuration
    config := ssh.ClientConfig{
        User: user,
        Auth: auths,
        // Uncomment to ignore host key check
        //HostKeyCallback: ssh.InsecureIgnoreHostKey(),
        HostKeyCallback: ssh.FixedHostKey(hostKey),
    }

    addr := fmt.Sprintf("%s:%d", host, port)

    // Connect to server
    conn, err := ssh.Dial("tcp", addr, &config)
    if err != nil {
        fmt.Fprintf(os.Stderr, "Failed to connecto to [%s]: %v\n", addr, err)
        os.Exit(1)
    }

    defer conn.Close()

    // Create new SFTP client
    sc, err := sftp.NewClient(conn)
    if err != nil {
        fmt.Fprintf(os.Stderr, "Unable to start SFTP subsystem: %v\n", err)
        os.Exit(1)
    }
    defer sc.Close()
}

// Get host key from local known hosts
func getHostKey(host string) ssh.PublicKey {
    // parse OpenSSH known_hosts file
    // ssh or use ssh-keyscan to get initial key
    file, err := os.Open(filepath.Join(os.Getenv("HOME"), ".ssh", "known_hosts"))
    if err != nil {
        fmt.Fprintf(os.Stderr, "Unable to read known_hosts file: %v\n", err)
        os.Exit(1)
    }
    defer file.Close()
 
    scanner := bufio.NewScanner(file)
    var hostKey ssh.PublicKey
    for scanner.Scan() {
        fields := strings.Split(scanner.Text(), " ")
        if len(fields) != 3 {
            continue
        }
        if strings.Contains(fields[0], host) {
            var err error
            hostKey, _, _, _, err = ssh.ParseAuthorizedKey(scanner.Bytes())
            if err != nil {
                fmt.Fprintf(os.Stderr, "Error parsing %q: %v\n", fields[2], err)
                os.Exit(1)
            }
            break
        }
    }
 
    if hostKey == nil {
        fmt.Fprintf(os.Stderr, "No hostkey found for %s", host)
        os.Exit(1)
    }
 
    return hostKey
}
```
